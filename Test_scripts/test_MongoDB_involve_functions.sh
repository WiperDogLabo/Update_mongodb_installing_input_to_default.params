 #!/bin/bash
if [ "$#" == 0 ];then
	echo "Incorrect script parameters"
	echo "Usage: ./test_MongoDB_involve_functions.sh path/to/wiperdog_installer_jar"
	echo "Example : ./test_MongoDB_involve_functions.sh wiperdog-0.2.5-SNAPSHOT-unix.jar"
	exit
fi
 wdInstaller=$1
 baseDir=$(pwd)
 wdDir=$baseDir/wiperdog-0.2.5-SNAPSHOT
echo "==============TEST Wiperdog Function involved to MongoDB =================="
echo "--Test wiperdog functions after updating user input to default params & move Restful port to configuration file--"
echo "--Please start mongoDB on localhost or specific configured host correspoding to testcase--"
echo "-----------------------------------------------------------------------------------------"
echo "Case 1: Run job and send data to MongoDB to default MongoDB host"
echo "** Clean data..."
sudo rm -rf $wdDir
if [ -d $wdDir ]; then
	echo "Failure to clean data .."
	exit
fi
echo "** Install wiperdog..."
expect<<DONE
	spawn java -jar $wdInstaller
	expect "Press any key to start interactive installation*"
	send "\r"
	expect "Do you want to install wiperdog at*"
	send "y\r"
	expect "Getting input parameters for pre-configured*"
	send "\r"
	sleep 1
	expect "Please input Netty port*"
	send "\r"
	sleep 1
	expect "Please input Restful service port*"
	send "\r"
	sleep 1
	expect "Please input job directory*"
	send "\r"
	sleep 1
	expect "Please input trigger directory*"
	send "\r"
	sleep 1
	expect "Please input job class directory*"
	send "\r"
	sleep 1
	expect "Please input job instance directory*"
	send "\r"
	sleep 1
	expect "Please input database server (Mongodb) IP address (default set to 127.0.0.1)*"
	send "\r"
	sleep 1
	expect "Please input database server port*"
	send "\r"
	sleep 1
	expect "Please input database name*"
	send "\r"
	sleep 1
	expect "Please input database server user name*"
	send "\r"
	sleep 1
	expect "Please input database server password*"
	send "\r"
	sleep 1
	expect "Please input mail send data policy*"
	send "\r"
	sleep 1
	expect "Do you want to install wiperdog as system service*"
	send "no\r"
	sleep 1
	expect "Your input are correct(Y|y|N|n)*"
	send "y\r"
	sleep 1
	expect "Finish the Wiperdog installation*"
	sleep 1
DONE
echo "** Clean wiperdog before run job.."
rm -rf $wdDir/var/job/*
rm -rf wd_stdout.log
echo "** Copy job and trigger file to job directory"
cp test_involve_functions/case_1/testjob.job $wdDir/var/job
cp test_involve_functions/case_1/test.trg $wdDir/var/job
echo "** Stop existing wiperdog..."
fuser -k 13111/tcp
echo "** Starting wiperdog ...Waitting for a minute..."
if [ -d $wdDir ];then
    $wdDir/bin/startWiperdog.sh > wd_stdout.log 2>&1 &
    sleep 60
    mongoMessage=$( cat wd_stdout.log | grep "Done send data to mongo DB" )
	if [[ $mongoMessage =~ .*'Done send data to mongo DB at 127.0.0.1'.* ]] ;then
		echo "** Data sent to MongoDB at 127.0.0.1 : PASSED"
	else
		echo "** Failure to sent data to MongoDB at 127.0.0.1 : FAILED"
		exit
	fi
else
	echo "Case 1: Failed "
	echo "Wiperdog directory not found after install !"
	exit
fi

sleep 10

echo "Case 2: Run job and send data to MongoDB to remote MongoDB host"
echo "** Clean data..."
sudo rm -rf $wdDir
if [ -d $wdDir ]; then
	echo "Failure to clean data .."
	exit
fi

mongoDBHost="10.0.0.154"
mongoDBPort="27017"
mongoDBName="wiperdog_test"
echo "** Install wiperdog with information :"
echo "MongoDB host: $mongoDBHost"
echo "MongoDB port: $mongoDBPort"
echo "MongoDB database name: $mongoDBName"
echo "** You can modified above information in testcase"
sleep 5
expect<<DONE
	spawn java -jar $wdInstaller
	expect "Press any key to start interactive installation*"
	send "\r"
	expect "Do you want to install wiperdog at*"
	send "y\r"
	expect "Getting input parameters for pre-configured*"
	send "\r"
	sleep 1
	expect "Please input Netty port*"
	send "\r"
	sleep 1
	expect "Please input Restful service port*"
	send "\r"
	sleep 1
	expect "Please input job directory*"
	send "\r"
	sleep 1
	expect "Please input trigger directory*"
	send "\r"
	sleep 1
	expect "Please input job class directory*"
	send "\r"
	sleep 1
	expect "Please input job instance directory*"
	send "\r"
	sleep 1
	expect "Please input database server (Mongodb) IP address (default set to 127.0.0.1)*"
	send "$mongoDBHost\r"
	sleep 1
	expect "Please input database server port*"
	send "$mongoDBPort\r"
	sleep 1
	expect "Please input database name*"
	send "$mongoDBName\r"
	sleep 1
	expect "Please input database server user name*"
	send "\r"
	sleep 1
	expect "Please input database server password*"
	send "\r"
	sleep 1
	expect "Please input mail send data policy*"
	send "\r"
	sleep 1
	expect "Do you want to install wiperdog as system service*"
	send "no\r"
	sleep 1
	expect "Your input are correct(Y|y|N|n)*"
	send "y\r"
	sleep 1
	expect "Finish the Wiperdog installation*"
	sleep 1
DONE
echo "** Clean wiperdog before run job.."
rm -rf $wdDir/var/job/*
rm -rf wd_stdout.log
echo "** Copy job and trigger file to job directory"
cp test_involve_functions/case_1/testjob.job $wdDir/var/job
cp test_involve_functions/case_1/test.trg $wdDir/var/job
echo "** Stop existing wiperdog..."
fuser -k 13111/tcp
echo "** Starting wiperdog ...Waitting for a minute..."
if [ -d $wdDir ];then
    $wdDir/bin/startWiperdog.sh > wd_stdout.log 2>&1 &
    sleep 60
    mongoMessage=$( cat wd_stdout.log | grep "Done send data to mongo DB" )
	if [[ $mongoMessage =~ .*'Done send data to mongo DB at 10.0.0.154'.* ]] ;then
		echo "** Data sent to MongoDB at 10.0.1.154 : PASSED"
		echo "=========== CASE 2 : PASSED"
	else
		echo "** Failure to sent data to MongoDB at 10.0.1.154 : FAILED"
		echo "=========== Case 2: FAILED"
		exit
	fi
else
	echo "========== Case 2: FAILED "
	echo "Wiperdog directory not found after install !"
	exit
fi

sleep 10
