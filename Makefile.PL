use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'PHP::Perlinfo',
    VERSION           => '0.05',
    PM 		      =>             
    			{
			'lib/Perlinfo.pm'        => '$(INST_LIBDIR)/Perlinfo.pm',
			'lib/Perlinfo/HTML.pm'   => '$(INST_LIBDIR)/Perlinfo/HTML.pm',
                      	},
		      
    PREREQ_PM	      => {IO::Stringy => 0}, 
);
