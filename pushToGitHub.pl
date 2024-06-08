#!/usr/bin/perl -I/home/phil/perl/cpan/DataTableText/lib/
#-------------------------------------------------------------------------------
# Push testPDM to GitHub
# Philip R Brenan at gmail dot com, Appa Apps Ltd Inc., 2023
#-------------------------------------------------------------------------------
use warnings FATAL => qw(all);
use strict;
use Carp;
use Data::Dump qw(dump);
use Data::Table::Text qw(:all);
use GitHub::Crud qw(:all);
use feature qw(say current_sub);

my $home = currentDirectory;                                                    # Local files
my $user = q(philiprbrenan);                                                    # User
my $repo = q(testPDM);                                                          # Repo
my $wf   = q(.github/workflows/main.yml);                                       # Work flow on Ubuntu

if (1)                                                                          # Documentation from pod to markdown into read me with well known words expanded
 {push my @files, searchDirectoryTreesForMatchingFiles($home, qw(.toml .pl .py .toml .pdm-python));

  for my $s(@files)                                                             # Upload each selected file
   {next if $s =~ m(\.pdm|\.venv);
    my $c = readBinaryFile $s;                                                  # Load file
    my $t = swapFilePrefix $s, $home;
    my $w = writeFileUsingSavedToken($user, $repo, $t, $c);
    lll "$w $s $t";
   }
 }

if (1)
 {my $d = dateTimeStamp;
  my $y = <<"END";
# Test $d

name: Test
run-name: Test Pdm

on:
  push:
    paths:
      - '**/main.yml'

jobs:

  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout\@v3
      with:
        ref: 'main'

    - name: Python version
      run: |
        python3 -V

    - name: Pip version
      run: |
        pip3 -V

    - name: Install pdm
      run: |
        pip3 install pdm

    - name: Install Tree
      run: |
        sudo apt install tree

    - name: package
      run: |
        pdm init -n
        cp pyproject2.toml pyproject.toml   # Use our description rather than the generated one
        pdm build
        tree

    - name: Install
      run: |
        sudo pip3 install /home/runner/work/testPDM/testPDM/dist/testPdm-0.1.0-py3-none-any.whl

    - name: Show libraries
      run: |
        pip3 show -f testpdm
        ls -la /usr/local/lib/python3.10/dist-packages/

    - name: Run command line
      run: |
        testPdmAaa
        testPdmBbb
END

  my $f = writeFileUsingSavedToken $user, $repo, $wf, $y;                       # Upload workflow
  lll "Ubuntu work flow for $repo written to: $f";
 }
