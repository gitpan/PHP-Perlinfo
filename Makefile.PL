use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'PHP::Perlinfo',
    VERSION           => '0.06',
    PM 		      =>             
    			{
			'lib/PHP/Perlinfo.pm'        => '$(INST_LIBDIR)/Perlinfo.pm',
			'lib/PHP/Perlinfo/HTML.pm'   => '$(INST_LIBDIR)/Perlinfo/HTML.pm',
                      	},
		      
    PREREQ_PM	      => {IO::Stringy => 0}, 
);
