use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'PHP::Perlinfo',
    VERSION           => '0.08',
    PM 		      =>             
    			{
			'lib/PHP/Perlinfo.pm'             => '$(INST_LIBDIR)/Perlinfo.pm',
			'lib/PHP/Perlinfo/HTML.pm'        => '$(INST_LIBDIR)/Perlinfo/HTML.pm',
			'lib/PHP/Perlinfo/Apache.pm'      => '$(INST_LIBDIR)/Perlinfo/Apache.pm',
			'lib/PHP/Perlinfo/License.pm'     => '$(INST_LIBDIR)/Perlinfo/License.pm',
			'lib/PHP/Perlinfo/Credits.pm'     => '$(INST_LIBDIR)/Perlinfo/Credits.pm',
			'lib/PHP/Perlinfo/General.pm'     => '$(INST_LIBDIR)/Perlinfo/General.pm',
			'lib/PHP/Perlinfo/Modules.pm'     => '$(INST_LIBDIR)/Perlinfo/Modules.pm',
			'lib/PHP/Perlinfo/Variables.pm'   => '$(INST_LIBDIR)/Perlinfo/Variables.pm',
                      	},
		      
    PREREQ_PM	      => {	IO::Stringy => 0,
    				File::Which => 0,
				App::Info   => 0,
			 },
    AUTHOR   => 'Mike Accardo (mikeaccardo@yahoo.com)',



    
);
