my $os  = `uname -s`;
   $os  = $^O unless chomp($os);

my $cpu = `uname -m`;
   $cpu = $^O unless chomp($cpu);

open(OUTFILE,">macros.inc");

if ($os =~ /Linux/i) {
  my $compiler = getcmpl();

  $compiler =~ s#.*/##;

  if ( $compiler eq "ifort" )
  {
    print OUTFILE "##############################################################################\n";
    print OUTFILE "# IA32_Intel/x86-64_Intel:	Intel Pentium with Linux using Intel compiler 11.\n";
    print OUTFILE "##############################################################################\n";
    my $flags_opt = exists $ENV{FLAGS_OPT} ? $ENV{FLAGS_OPT} : "-O2";
    my $flags_msc = exists $ENV{FLAGS_MSC} ? $ENV{FLAGS_MSC} : "-g -traceback";
    print OUTFILE "F90_SER = ftn\n";
    print OUTFILE "F90_OMP = ftn\n";
    print OUTFILE "F90_MPI = ftn\n";
    print OUTFILE "FLAGS_OPT = $flags_opt\n";
    print OUTFILE "FLAGS_MSC = $flags_msc\n";
    print OUTFILE "FLAGS90_MSC = \$(FLAGS_MSC)\n";
    print OUTFILE "FLAGS_DYN = -fPIC\n";
    print OUTFILE "FLAGS_SER =\n";
    print OUTFILE "FLAGS_OMP = -openmp\n";
    print OUTFILE "FLAGS_MPI =\n";
#    print OUTFILE "NETCDFROOT = \$(NETCDF) \n";
#    print OUTFILE "ifneq (\$(NETCDF),)\n";
#    print OUTFILE "  INCS_SER = -I\$(NETCDF_INCLUDES) \n";
#    print OUTFILE "  INCS_OMP = -I\$(NETCDF_INCLUDES) \n";
#    print OUTFILE "  INCS_MPI = -I\$(NETCDF_INCLUDES) \n";
#    print OUTFILE "  LIBS_SER = -L\$(NETCDF_LIBRARIES) -lnetcdff -lnetcdf -L\$(HDF5_LIBRARIES) -lhdf5_hl -lhdf5hl_fortran -lhdf5 -lhdf5_fortran \$(Z_LIB)\n";
#    print OUTFILE "  LIBS_OMP = -L\$(NETCDF_LIBRARIES) -lnetcdff -lnetcdf -L\$(HDF5_LIBRARIES) -lhdf5_hl -lhdf5hl_fortran -lhdf5 -lhdf5_fortran \$(Z_LIB)\n";
#    print OUTFILE "  LIBS_MPI = -L\$(NETCDF_LIBRARIES) -lnetcdff -lnetcdf -L\$(HDF5_LIBRARIES) -lhdf5_hl -lhdf5hl_fortran -lhdf5 -lhdf5_fortran \$(Z_LIB)\n";
    print OUTFILE "NETCDF_C_HOME = \$(shell nc-config --prefix)\n";
    print OUTFILE "NETCDF_F_HOME = \$(shell nf-config --prefix)\n";
    print OUTFILE "HDF5HOME = \$(hdf5_ROOT)\n";
    print OUTFILE "NETCDF_C_INCLUDES = -I\$(NETCDF_C_HOME)/include\n";
    print OUTFILE "NETCDF_F_INCLUDES = -I\$(NETCDF_F_HOME)/include\n";
    print OUTFILE "HDF5_INCLUDES = -I\$(HDF5HOME)/include\n";
    print OUTFILE "NETCDF_C_LIBS = -L\$(NETCDF_C_HOME)/lib -lnetcdf\n";
    print OUTFILE "NETCDF_F_LIBS = -L\$(NETCDF_F_HOME)/lib -lnetcdff\n";
    print OUTFILE "HDF5_LIBS = -L\$(HDF5HOME)/lib -lhdf5_hl -lhdf5_hl_fortran -lhdf5 -lhdf5_fortran\n";

    print OUTFILE "ifneq (\$(NETCDF_C_HOME),)\n";
    print OUTFILE "  INCS_SER = \$(NETCDF_C_INCLUDES) \$(NETCDF_F_INCLUDES) \$(HDF5_INCLUDES)\n";
    print OUTFILE "  INCS_OMP = \$(NETCDF_C_INCLUDES) \$(NETCDF_F_INCLUDES) \$(HDF5_INCLUDES)\n";
    print OUTFILE "  INCS_MPI = \$(NETCDF_C_INCLUDES) \$(NETCDF_F_INCLUDES) \$(HDF5_INCLUDES)\n";
    print OUTFILE "  LIBS_SER = \$(NETCDF_F_LIBS) \$(NETCDF_C_LIBS) \$(HDF5_LIBS) \$(Z_LIB)\n";
    print OUTFILE "  LIBS_OMP = \$(NETCDF_F_LIBS) \$(NETCDF_C_LIBS) \$(HDF5_LIBS) \$(Z_LIB)\n";
    print OUTFILE "  LIBS_MPI = \$(NETCDF_F_LIBS) \$(NETCDF_C_LIBS) \$(HDF5_LIBS) \$(Z_LIB)\n";

    print OUTFILE "  NCF_OBJS = nctablemd.o agioncmd.o swn_outnc.o\n";
    print OUTFILE "else\n";
    print OUTFILE "  INCS_SER =\n";
    print OUTFILE "  INCS_OMP =\n";
    print OUTFILE "  INCS_MPI =\n";
    print OUTFILE "  LIBS_SER =\n";
    print OUTFILE "  LIBS_OMP =\n";
    print OUTFILE "  LIBS_MPI =\n";
    print OUTFILE "  NCF_OBJS =\n";
    print OUTFILE "endif\n";
    print OUTFILE "O_DIR = ../estofs_padcirc.fd/work/odir4/\n";
    print OUTFILE "OUT = -o \n";
    print OUTFILE "EXTO = o\n";
    print OUTFILE "MAKE = make\n";
    print OUTFILE "RM = rm -f\n";
    print OUTFILE "ifneq (\$(NETCDF_C_HOME),)\n";
    print OUTFILE "  swch = -unix -impi -netcdf\n";
    print OUTFILE "else\n";
    print OUTFILE "  swch = -unix -impi\n";
    print OUTFILE "endif\n";
  }
  else
  {
    die "Current Fortran compiler '$compiler' not supported.... \n";
  }
}

close(OUTFILE);

# =============================================================================

sub getcmpl {

   my $compiler = $ENV{'FC'};

   unless ( $compiler ) {
      foreach ('ifort','f90','ifc','efc','pgf90','xlf90', 'lf95','gfortran','g95') {
         $compiler = $_;
         my $path  = `which $compiler`;
         last if $path;
      }
   }

   return $compiler;
}

# =============================================================================
