using LocalCoverage
# pkg is the package name as a string, e.g. "LocalCoverage"
generate_coverage("PathsSet", genhtml=true, show_summary=true, genxml=false)
clean_coverage("PathsSet", rm_directory=false)
