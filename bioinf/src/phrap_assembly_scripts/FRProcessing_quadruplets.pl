#!/usr/bin/perl

use warnings;
use strict;
use Cwd;
use File::Basename;
use File::Copy;
use File::Path;
use Bio::SeqIO;

#changelog
#Nov 9, 2010 - changed the echo -e statment to printf as Ubuntu uses dash, not bash.

#April 23, 2013 changed to accept 4 read sets a oppose to 3 Nate Olson NIST nolson@nist.gov

##aims
#People often want to process a set of forward and reverse sequence read pairs. Sometimes you might have a set of 
#three sequences that should be assembled together. This can be done using phred,
#and phrap through the Staden interface. However, this is tedious if there are many read sets to process. 
#
#This script takes forward reads held in one directory, reverse reads held in another directory, and a third
#sequence (e.g. middle sequence) held in yet another directory,  and processes
#them using whatever modules you have setup in your phred parameter file. 
#The assembled read sets are all loaded into a single gap4 database.
#
#This script has certain things hardcoded into it (see "assumptions" below), but should be relatively easy to edit.
#
# The likely things to require editing are
###The function that reads in forward, reverse and other sequence names and recognises which sequences form a set. Note the $fileNamingType variable associated with this.
###Associated with this - the assumption that forward, reverse and other sequence files are held in separate directories.

##assumptions
#Assume that the Staden package, phred and phrap are installed and all programs are on the user's path.
#Any file ending in .aux is a working gap4 database that can be appended to
#Assume files are ABI files that end in .ab1
#Assume that at least part of the sequence names for a given set of sequences are the same, so that 
#we can figure out which sequences from each directory should be assembled together. 
#Here, we assume that you want your contigs to be named with the all the letters apart from the
#last 13 letters, of the Forward read name. This script has the naming system set to "Lindsay". You should
#check anything that looks at whether the naming is set to Lindsay and change the naming choices according to your needs. 
#Assume that if the full name to a gap database is not given, then it is the .0.aux version
#Assume that gap4 database versions do not run higher than 9

##additional notes
#
#Before each run of pregap4, the parameter file is changed so the fasta output file names change
#Due to limitations of the staden system, the "original" gap4 database is copied into outDir and then appended to.
#Because the removal of the .BUSY file for the gap4 database is a bit slow, we have a "sleep 2"  statement after the
#pregap command. This slows the running of this program down substantially, but without a little sleep time, the program sometimes
#gets twisted up because of the BUSY file. Decrease the sleep time to less than 2 at your own peril.


###niceties that could be added
#Check last version of gap4 database and increment in the next run (currently runs with whatever version you started with.)
#


#the naming type flag can be used to set different naming schemes later in the script.
#if the naming type is Lindsay, then a function is called to rename all her forward traces at the beginning so that
#her consensus seqs are named as she wants
my $fileNamingType = "Lindsay";


my $gap4db = checkForGap4db();


my $fdirName = readInDir("forward");
my $rdirName = readInDir("reverse");
my $mdirName1 = readInDir("middle sequence 1");
my $mdirName2 = readInDir("middle sequence 2");

#check F and R dirs are not the same - if they are, we'll have to write
#a function that parses out which is which by name. This is not included in this version of the script.

if ($fdirName eq $rdirName)
{
 print "\nForward, reverse and/or middle sequences in the same directory are not supported in this script. Sorry.\n\n";
 exit;
}

my $pregapParams = getPregapParams();

#my $gap4FirstFile = substr($gap4db,0, -4);
my $gap4NameOnly = substr($gap4db,0, -6);
#my $gap4LogFile = $gap4db;
#$gap4LogFile =~ s/aux/log/;

unless (-d "readPairFastaSeqs")
{
  mkdir ("readPairFastaSeqs") or die "Problem making directory readPairFastaSeqs: $!\n";
}

#now match up F and R read names

my @forwardFiles = <$fdirName/*.ab1>;
my @reverseFiles = <$rdirName/*.ab1>;
my @middleFiles1 = <$mdirName1/*.ab1>;
my @middleFiles2 = <$mdirName2/*.ab1>;


my $fFileNumber = @forwardFiles;
my $rFileNumber = @reverseFiles;
my $mFileNumber1 = @middleFiles1;
my $mFileNumber2 = @middleFiles2;

#the following should be possible using map and basename, but I could not seem to get the correct command.
#So, doing it the longwinded way

my @revFileNames = ();
foreach my $i (@reverseFiles)
{
       my $filename = basename($i);
       push (@revFileNames, $filename);
}

my @middleFileNames1 = ();
foreach my $i (@middleFiles1)
{
       my $filename = basename($i);
       push (@middleFileNames1, $filename);
}

my @middleFileNames2 = ();
foreach my $i (@middleFiles2)
{
       my $filename = basename($i);
       push (@middleFileNames2, $filename);
}


my $count = 1;
if  ($fileNamingType eq "Lindsay")  #
{

  foreach (@forwardFiles)
  {
    my $fullForwardName = $_;
    my $fseqname = basename($fullForwardName);
    #take the first 9 characters of F sequence and remove the .ab1
    #my $barcode = substr($fseqname, 0, -13);
    #changed for my reads nate olson 4/22/2013 use 0,4 for NIST and 0,10 for LGC
    my $barcode = substr($fseqname, 0, 10);

    my @grepRev = grep(/^$barcode/, @revFileNames);
    my @grepMiddle1 = grep(/^$barcode/, @middleFileNames1);
    my @grepMiddle2 = grep(/^$barcode/, @middleFileNames2);

    my $arrayRSize = @grepRev;
    my $arrayMSize1 = @grepMiddle1;
    my $arrayMSize2 = @grepMiddle2;

    if  (($arrayRSize > 1) or ($arrayMSize1 > 1) or ($arrayMSize2 > 1))
    {
     print "This script assumes only one reverse, one middle 1, and one middle 2 reads for a given barcode. I have just found more than one matching sequence for for $barcode. Exiting\n.";
     exit;
    }

    elsif (($arrayRSize < 1) or ($arrayMSize1 < 1) or ($arrayMSize2 < 1))
    {
     print "Warnings: there is a missing read partner (reverse, middle 1, or middle 2 read) for the forward sequence with barcode $barcode\n";
     next;
    }

    else
    { #implicit that your size = 1

     my $rseqname = $rdirName . "/" . $grepRev[0];   #just for simplicity
     my $mseqname1 = $mdirName1 . "/" . $grepMiddle1[0];
     my $mseqname2 = $mdirName2 . "/" . $grepMiddle2[0];

     my $newParamFile = editPregapParamFile($barcode, $pregapParams, $gap4NameOnly);

     #pregap only understands a file of filenames so...
     my $fofn = "fofn.txt";      #if you change this, then make sure you change the info in the cleanUp routine.
     open (FOFN, ">$fofn") or die "Couldn't open $fofn to write file names to: $!\n";

     if  ($fileNamingType eq "Lindsay")
     {
#change the name of the forward sequence - in this case, make a copy and use this as the F seq in the assembly.
       copy($fullForwardName,$barcode) or die "Copy f sequence with new name failed: $!";
       print FOFN "$barcode\n";
       print FOFN "$mseqname1\n";
       print FOFN "$mseqname2\n";
       print FOFN "$rseqname";
     
     }
     else
    { #most people probably don't want to change the name of the foward sequence, which is covered here
       print FOFN "$fullForwardName\n";
       print FOFN "$mseqname1\n";
       print FOFN "$mseqname2\n";
       print FOFN "$rseqname";
    }

     close (FOFN);

     my $command = "pregap4 -nowin -config $newParamFile -fofn $fofn >> pregap4.log";
     system($command);


	#now extract sequences. 
        #have to run this command separately now as extract_seq doesn't work via pregap4 interface as of
        #staden version 1.7.0
        #
        #need files in fofn to read .exp instead of ab1 at this point.
        my $fofnExtract = $fofn . ".extract";
	my $fexp;
	if ($fileNamingType eq "Lindsay")
	{
		$fexp = "$barcode.exp";
	}
	else
	{
		$fexp = $fseqname; $fexp =~ s/ab1/exp/;	
	}	 

	my $mexp1 = $grepMiddle1[0]; $mexp1 =~s/ab1/exp/;
        my $mexp2 = $grepMiddle2[0]; $mexp2 =~s/ab1/exp/;
        my $rexp = $grepRev[0]; $rexp =~s/ab1/exp/;

        `printf "$fexp\n$mexp1\n$mexp2\n$rexp" > $fofnExtract`;
        `extract_seq  -fofn $fofnExtract -good_only -fasta_out -clip_cosmid | tee readPairFastaSeqs/$barcode.fasta`;

#check for good sequences. Reports back to user.
        my @seqlengths = getSeqLengths("readPairFastaSeqs/$barcode.fasta");
        open (LOG, ">>pregap4.log") or warn "Can't write this message to pregap4.log\n";
        my $warning =  "$fseqname has $seqlengths[0] quality bases.\n$grepMiddle1[0] has $seqlengths[1] quality bases\n$grepMiddle1[0] has $seqlengths[2] quality bases\n$grepRev[0] has $seqlengths[3] quality bases.\n";
        print $warning;
        print LOG $warning;
        close LOG;

     print "$count read sets processed.\n";
     sleep 2;  #this is here because there is sometimes an issue where the BUSY file is not deleted
               #quickly enough for the gap4 database. And thus ensues much knickers-in-twistiness.
               #sleep less than 2 at your own peril. It goes wrong for me with any less than this.
     $count++;
    }
  }
}     #end of checks on if naming scheme is Lindsay. Probably this check should end sooner, and a flag should be set.

else
{
 print "You'll need to define the naming system you want in here\n";
 exit;

}

cleanup();

$gap4db=~s/aux/BUSY/;  #check for a BUSY file on the database. Sometimes this gets left.
if (-e $gap4db ) {unlink($gap4db);}

print "\n\nThe script is finished. Results are in the gap4 database $gap4NameOnly.\nIf sequence pairs are not in the assembly, it may be because at least one sequence \ndid not have enough quality sequence and/or no sequence match between the reads was found.\nFurther details are recorded in the pregap4.log file in this directory.\n\n";


##########################

sub checkForGap4db
{


  my $gap4db;

  print "You must already have a gap4 database in this directory for results to be loaded into.\n";
  print "Please supply the name of the gap4 database you wish to use: ";

  $gap4db = <STDIN>;
   chomp($gap4db);
   if ($gap4db eq 'q') {exit;}

   #does the name they give end with .aux? yes - then keep it? No - then add it.
   
   unless ($gap4db =~ /\.{\d}?\.aux$/)
     {
      $gap4db = $gap4db . ".0.aux";
     }

   unless (-e $gap4db)
    {
      print "The gap4 database $gap4db doesn't exist. Please give the database name again, or press 'q' to quit, then create your gap4 database and try again\n\n";
      checkForGap4db();

    }
    print "The gap4 database $gap4db will be appended to.\n\n";
    return $gap4db;


}



############

sub readInDir
{
   my $direction = shift;
   my $dirName;
   
   print "Please give the full path of your $direction sequence read directory. Or press 'q' to quit: ";
   $dirName = <STDIN>;
   chomp($dirName);
   if ($dirName eq 'q') {exit;}
   
   unless (-d $dirName)
    {
     $dirName = print "That directory doesn't exist. Please try again, or press 'q' to quit\n\n";
      readInDir($direction);
    
    }
    
    return $dirName;

}


##############

#code left in for posterity. No longer used because Staden doesn't give us the option of dumping the databse,
#etc in a subdirectory. So now script dumps everything in current directory...no need to create any subdirs.
#sub createDir
#{
#   my $dirName = "";
#
#   print "Please give the name of the folder you wish output to be written to.\n A directory of that name will be created here.\n";
#   $dirName = <STDIN>;
#   chomp($dirName);
#   if ($dirName eq 'q') {exit;}
#
#   if (-d $dirName)
#    {
#      print "That directory already exists. Please give a new directory name, or press 'q' to quit\n\n";
#      $dirName = createDir();
#    }
#    else
#    {
#    mkdir($dirName) or die "Couldn't create output directory $dirName: $!\n\n";
#    }
#
#    return $dirName;
#
#}

############

sub getPregapParams
{


  my $pregapParams;

  print "Please supply the full path to your pre-defined pregap4 parameter file: ";

  $pregapParams = <STDIN>;
   chomp($pregapParams);
   if ($pregapParams eq 'q') {exit;}

   unless (-e $pregapParams)
    {
      print "The file $pregapParams doesn't exist. Please give the filename again, or press 'q' to quit, then create your parameter file, and try again\n\n";
      $pregapParams = getPregapParams();

    }
    print "The pregap parameters in $pregapParams will be used.\n\n";
    return $pregapParams;


}

#########

sub editPregapParamFile
{

  my $barcode = shift;
  my $pregapParams = shift;
  my $gap4Name = shift;

  my $fastaOut = $barcode . ".fasta";

	my $tls = $/;
	undef  $/;

  	open (PARAMFILE, "<$pregapParams") or die "I can't open the pregap parameter file copy to edit: $!\n";
 	my @newInf = ();
 	my $newInf =  <PARAMFILE>;

	$newInf =~ s/(quality_clip\]\n *set enabled) 1/$1 0/;

        #turn on phrap assembly if it is off. Turn on enter into gap4 assembly if is off.
        $newInf =~ s/(phrap_assemble\]\n *set enabled) 0/$1 1/;

        #navigate to the [::enter_assembly] line and from there search and change info below.
        $newInf =~ s/(enter_assembly\]\n *set enabled) 0/$1 1/;

        #make sure that the file is set to append to database rather than create new ones
        $newInf =~ s/set create 1/set create 0/;

        #change the name of the gap4 database in the parameter file to match the one entered on the command line.
        $newInf =~ s/(enter_assembly\]\n *set enabled 1\n.*set database_name) .*/$1 $gap4Name/;


  close(PARAMFILE);

    my $newparam = "tmpParams.txt";
    open(NPARAM, ">$newparam") or die "I can't open $newparam: $!\n";
    print NPARAM $newInf;
    close NPARAM;

$/=$tls;

#couldn't get the below to work. Don't know why. Go back to old way...
#  my $command = "/usr/bin/perl -p -i.bak -e 's!set file_name singleReadPairs/.*.fasta!set file_name singleReadPairs\/$fastaOut!' $pregapParamFile";
#  system($command) or warn "couldn't execute perl oneliner: $!\n";

return $newparam;

}

#########

sub cleanup
{
 rmtree("fofn.txt.assembly");
 my @fofnfiles = glob "*fofn.*";

 foreach (@fofnfiles)
 {
     unlink($_);
  }

 unlink("tmpParams.txt");

  return;

}

##############

sub getSeqLengths
{
  my $fastaFile = shift;

  my $inputstream = Bio::SeqIO->new(-file => $fastaFile,-format => 'Fasta');
  my @seqLengths = ();
  while (my  $seqobj = $inputstream->next_seq())
  {
    push (@seqLengths, $seqobj->length())
  }

return (@seqLengths);

}

