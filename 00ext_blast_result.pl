$out_dir = "./result";
system "rm  -rf $out_dir";
system "mkdir $out_dir";


$input_dir = "./BlastResultFolder";
@files = <$input_dir/*>;
foreach $file (@files)
{

	@file_name = ($file=~ /\.\/BlastResultFolder\/(\S+)\.\S+/);	
	open TXT1 , "<$file" or die "can't open file1:$!";

	$out_file_1 = "$out_dir/@file_name\_list.txt";
	system "rm $out_file_1";
	open OUT1 , ">>./$out_file_1";

	$out_file_2 = "$out_dir/@file_name\_ext.txt";
	system "rm $out_file_2";
	open OUT2 , ">>./$out_file_2";

	@array_1 = ();
	@array_2 = ();
	@rows = ();
	$keys1 = 0;
	$keys2 = 0;

	while(<TXT1>)
	{
		chomp;

		if($_=~/\#\s.*/)
		{
			push @array_1, $_;

		}

		if($_=~/\#\sQuery: (\S+)\s+.*/)
		{
			$Que = $1;

		}

		if($_=~/\#\sBLASTN.*/ or eof(TXT1))
		{
	

			$keys1 = keys(%sub_acc_check);

			$keys2 = keys(%sub_gene_check);



			if($i > 1 && $keys1 > 1 && $keys2 < 3)
			{
				if($sub_check{"0"} eq "C1")
				{

					print OUT1 "$Que\n";

					foreach $line1 (@array_1)
					{
						print OUT2 "$line1\n";
					}

					foreach $line2 (@array_2)
					{
						print OUT2 "$line2\n";
					}


				}

			}


			%sub_acc_check = ();
			%sub_gene_check = ();
			%sub_check = ();
			@array_1 = ();
			@array_2 = ();
			$keys1 = 0;
			$keys2 = 0;
			$i = 0;
			$query = "";
			$gene = "";
			$subject = "";
			$Que = "";	
		


		}else{

			if($_=~/^\S+\s+(\w{2,4})\_(\S+)\s+\S+\s+\d+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+(\d+(?:\.\d+)?+(?:e[+-]?\d+)?+)\s+\S+/)
			{
				$gene = $1;
				$subject = $2;
				$e_value = $3;

					if($e_value <= 1e-4)
					{
						$sub_gene_check{"$gene"} = 1;
						$sub_acc_check{"$subject"} = 1;

						$sub_check{"$i"} = $gene;
						push @array_2, $_;

						$i++;

					}

														
			}

		}
	
	}

}

