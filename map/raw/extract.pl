# Long, Lat
while (<>) {
    print "$1 $2,\n" while s/"longitude"\s*:\s*"([\.\d]+)"\s*,\s*"latitude"\s*:\s*"([\.\d]+)"//;
    print "$2 $1,\n" while s/"latitude"\s*:\s*"([\.\d]+)"\s*,\s*"longitude"\s*:\s*"([\.\d]+)"//;
}
