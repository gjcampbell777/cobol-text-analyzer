main: wordStat.cob
	cobc -x -free -Wall wordStat.cob

old: stat.cob
	cobc -x -free -Wall stat.cob

clean:
	rm out.txt stats.txt stat wordStat