################################################################################
# When using Clang, there is nothing to do: colors are enabled by default
# When using GCC >= 4.9, colored diagnostics can be enabled natively
# When using an older version, one can use gccfilter (a perl script)
#
# I do not recommend using gccfilter as of now (May 2014), because it seems to
# be bugged. But if you still want to try, here is how to install it on Ubuntu:
#
#
# 1) Download the perl script and add it to you $PATH
#    mkdir -p ~/.local/bin
#    wget -P ~/.local/bin http://www.mixtion.org/gccfilter/gccfilter
#    chmod +x ~/local/bin/gccfilter
#    echo 'PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
#
# 2) Install the dependencies
#  * Term::ANSIColor
#    sudo cpan
#    cpan> install Term::ANSIColor
#  * The module "Getopt::Long" is included in "perl-base"
#  * For Getopt::ArgvFile and Regexp::Common ...
#    sudo apt-get install libgetopt-argvfile-perl libregexp-common-perl
#
################################################################################

If (CMAKE_COMPILER_IS_GNUCXX)
	# If GCC >= 4.9, just activate the right option
	If (NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.9)
		Message(STATUS "GCC >= 4.9 detected, enabling colored diagnostics")
		Set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fdiagnostics-color=auto")
		Set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fdiagnostics-color=auto")
		Set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -fdiagnostics-color=auto")
		Return()
	Endif()
	# If GCC < 4.9, maybe we can use gccfilter
	Find_Program(GCC_FILTER gccfilter)
	If(GCC_FILTER)
		Option(COLOR_GCC "Use GCCFilter to color compiler output messages" OFF)
		Set(COLOR_GCC_OPTIONS "-c -r -w" CACHE STRING "Arguments that are passed to gccfilter when output coloring is switchend on. Defaults to -c -r -w.")
		If(COLOR_GCC)
			Set_Property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${GCC_FILTER} ${COLOR_GCC_OPTIONS}")
			Message(STATUS "Using gccfilter for colored diagnostics")
		Endif()
	Endif()
Endif()
