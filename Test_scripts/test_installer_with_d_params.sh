 #!/bin/bash
if [ "$#" == 0 ];then
	echo "Incorrect script parameters"
	echo "Usage: ./test_installer_with_d_params.sh path/to/wiperdog_installer_jar"
	echo "Example : ./test_installer_with_d_params.sh wiperdog-0.2.5-SNAPSHOT-unix.jar"
	exit
fi
 wdInstaller=$1
 baseDir=$(pwd)
 wdDir=$baseDir/wiperdog-0.2.5-SNAPSHOT
echo "==============TEST Wiperdog installer=================="
echo "--Test wiperdog installer after updating user input to default params & move Restful port to configuration file--"
echo "-------------------------------------------------"
echo "Case 1 : Install with only -d params (default input)"
echo "** Clean data..."
sudo rm -rf $wdDir
if [ -d $wdDir ]; then
	echo "Failure to clean data .."
	exit
fi
echo "** Install wiperdog..."
expect<<DONE
	#set wdInstaller [lindex $argv 0]
	spawn sudo java -jar $wdInstaller -d $wdDir 
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
echo "** Check configuration file ( default.params )"
if [ -d $wdDir ];then
	echo "** Netty port: "
	nettyPort=$( cat $wdDir/etc/system.properties | grep netty.port= )
	if [[ $nettyPort =~ .*'13111'.* ]] ; then
		echo $nettyPort : PASSED
	else
		echo $nettyPort : FAILED
		exit
	fi

	echo "** Restful server port: "
	restPort=$( cat $wdDir/etc/system.properties | grep rest.port= )
	if [[ $restPort =~ .*'8089'.* ]] ; then
		echo $restPort : PASSED
	else
		echo $restPort : FAILED
		exit
	fi
	echo "** Job directory: "
	jobDir=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.directory.job= )
	if [[ $jobDir =~ .*'${felix.home}/var/job'.* ]] ; then
		echo $jobDir : PASSED
	else
		echo $jobDir : FAILED
		exit
	fi	

	echo "** Trigger directory: "
	trgDir=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.directory.trigger= )
	if [[ $trgDir =~ .*'${felix.home}/var/job'.* ]] ; then
		echo $trgDir : PASSED
	else
		echo $trgDir : FAILED
		exit
	fi
	
	echo "** Jobclass directory: "
	jobClsDir=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.directory.jobcls= )
	if [[ $jobClsDir =~ .*'${felix.home}/var/job'.* ]] ; then
		echo $jobClsDir : PASSED
	else
		echo $jobClsDir : FAILED
		exit
	fi	

	echo "** Instances directory: "
	instDir=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.directory.instances= )
	if [[ $instDir =~ .*'${felix.home}/var/job'.* ]] ; then
		echo $instDir : PASSED
	else
		echo $instDir : FAILED
		exit
	fi	

	echo "** MongoDB server host: "
	mongoHost=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mongodb.host= )
	if [[ $mongoHost =~ .*'127.0.0.1'.* ]] ; then
		echo $mongoHost : PASSED
	else
		echo $mongoHost : FAILED
		exit
	fi

	echo "** MongoDB server port: "
	mongoPort=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mongodb.port= )
	if [[ $mongoPort =~ .*'27017'.* ]] ; then
		echo $mongoPort : PASSED
	else
		echo $mongoPort : FAILED
		exit
	fi

	echo "** MongoDB database name: "
	mongoDBName=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mongodb.dbName= )
	if [[ $mongoDBName =~ .*'wiperdog'.* ]] ; then
		echo $mongoDBName : PASSED
	else
		echo $mongoDBName : FAILED
		exit
	fi	

	echo "** MongoDB user name: "
	mongoUser=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mongodb.dbName= )
	if [[ $mongoUser =~ .*''.* ]] ; then
		echo $mongoUser : PASSED
	else
		echo $mongoUser : FAILED
		exit
	fi

	echo "** MongoDB password: "
	mongoPasswd=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mongodb.dbName= )
	if [[ $mongoPasswd =~ .*''.* ]] ; then
		echo $mongoPasswd : PASSED
	else
		echo $mongoPasswd : FAILED
		exit
	fi

	echo "** Policy Email: "
	email=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mail.toMail= )
	if [[ $email =~ .*'testmail@gmail.com'.* ]] ; then
		echo $email : PASSED
	else
		echo $email : FAILED
		exit
	fi
	echo "===========> Case 1 : PASSED"
else
	echo "===========> Case 1 : FAILED "
	echo "Wiperdog directory not found after install !"
	exit
fi
sleep 10
echo "-----------------------------------------------------------------------------------------"
echo "Case 2: Install with -d params (manual input)"
echo "** Clean data..."
sudo rm -rf $wdDir
if [ -d $wdDir ]; then
	echo "Failure to clean data .."
	exit
fi
echo "** Install wiperdog..."
expect<<DONE
	#set wdInstaller [lindex $argv 0]
	spawn sudo java -jar $wdInstaller -d $wdDir 
	expect "Getting input parameters for pre-configured*"
	send "\r"
	sleep 1
	expect "Please input Netty port*"
	send "13112\r"
	sleep 1
	expect "Please input Restful service port*"
	send "8888\r"
	sleep 1
	expect "Please input job directory*"
	send "$wdDir/jobdir\r"
	sleep 1
	expect "Please input trigger directory*"
	send "$wdDir/trgdir\r"
	sleep 1
	expect "Please input job class directory*"
	send "$wdDir/clsdir\r"
	sleep 1
	expect "Please input job instance directory*"
	send "$wdDir/instdir\r"
	sleep 1
	expect "Please input database server (Mongodb) IP address (default set to 127.0.0.1)*"
	send "10.0.1.111\r"
	sleep 1
	expect "Please input database server port*"
	send "27018\r"
	sleep 1
	expect "Please input database name*"
	send "wiperdog_test\r"
	sleep 1
	expect "Please input database server user name*"
	send "test_user\r"
	sleep 1
	expect "Please input database server password*"
	send "test_passwd\r"
	sleep 1
	expect "Please input mail send data policy*"
	send "test_mail_policy@hotmail.com\r"
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
echo "** Check configuration file ( default.params )"
if [ -d $wdDir ];then
	echo "** Netty port: "
	nettyPort=$( cat $wdDir/etc/system.properties | grep netty.port= )
	if [[ $nettyPort =~ .*'13112'.* ]] ; then
		echo $nettyPort : PASSED
	else
		echo $nettyPort : FAILED
		exit
	fi

	echo "** Restful server port: "
	restPort=$( cat $wdDir/etc/system.properties | grep rest.port= )
	if [[ $restPort =~ .*'8888'.* ]] ; then
		echo $restPort : PASSED
	else
		echo $restPort : FAILED
		exit
	fi
	echo "** Job directory: "
	jobDir=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.directory.job= )
	if [[ $jobDir =~ .*${wdDir}/jobdir.* ]] ; then
		echo $jobDir : PASSED
	else
		echo $jobDir : FAILED
		exit
	fi	

	echo "** Trigger directory: "
	trgDir=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.directory.trigger= )
	if [[ $trgDir =~ .*${wdDir}/trgdir.* ]] ; then
		echo $trgDir : PASSED
	else
		echo $trgDir : FAILED
		exit
	fi
	
	echo "** Jobclass directory: "
	jobClsDir=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.directory.jobcls= )
	if [[ $jobClsDir =~ .*${wdDir}/clsdir.* ]] ; then
		echo $jobClsDir : PASSED
	else
		echo $jobClsDir : FAILED
		exit
	fi	

	echo "** Instances directory: "
	instDir=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.directory.instances= )
	if [[ $instDir =~ .*${wdDir}/instdir.* ]] ; then
		echo $instDir : PASSED
	else
		echo $instDir : FAILED
		exit
	fi	

	echo "** MongoDB server host: "
	mongoHost=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mongodb.host= )
	if [[ $mongoHost =~ .*'10.0.1.111'.* ]] ; then
		echo $mongoHost : PASSED
	else
		echo $mongoHost : FAILED
		exit
	fi

	echo "** MongoDB server port: "
	mongoPort=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mongodb.port= )
	if [[ $mongoPort =~ .*'27018'.* ]] ; then
		echo $mongoPort : PASSED
	else
		echo $mongoPort : FAILED
		exit
	fi

	echo "** MongoDB database name: "
	mongoDBName=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mongodb.dbName= )
	if [[ $mongoDBName =~ .*'wiperdog_test'.* ]] ; then
		echo $mongoDBName : PASSED
	else
		echo $mongoDBName : FAILED
		exit
	fi	

	echo "** MongoDB user name: "
	mongoUser=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mongodb.user= )
	if [[ $mongoUser =~ .*'test_user'.* ]] ; then
		echo $mongoUser : PASSED
	else
		echo $mongoUser : FAILED
		exit
	fi

	echo "** MongoDB password: "
	mongoPasswd=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mongodb.pass= )
	if [[ $mongoPasswd =~ .*'test_passwd'.* ]] ; then
		echo $mongoPasswd : PASSED
	else
		echo $mongoPasswd : FAILED
		exit
	fi

	echo "** Policy Email: "
	email=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mail.toMail= )
	if [[ $email =~ .*'test_mail_policy@hotmail.com'.* ]] ; then
		echo $email : PASSED
	else
		echo $email : FAILED
		exit
	fi
	echo "===========> Case 2 : PASSED"
else
	echo "===========> Case 2 : FAILED "
	echo "Wiperdog directory not found after install !"
	exit
fi
echo "-----------------------------------------------------------------------------------------"
echo "Case 3: Install with -d params  and others (manual input)"
echo "** Clean data..."
sudo rm -rf $wdDir
if [ -d $wdDir ]; then
	echo "Failure to clean data .."
	exit
fi
echo "** Install wiperdog..."
expect<<DONE
	#set wdInstaller [lindex $argv 0]
	spawn sudo java -jar $wdInstaller -d $wdDir -r 8888 -m 10.0.1.111  -p 27018 -n wiperdog_test -s no 
	expect "Getting input parameters for pre-configured*"
	send "\r"
	sleep 1
	expect "Please input Netty port*"
	send "13112\r"
	sleep 1
	expect "Please input job directory*"
	send "$wdDir/jobdir\r"
	sleep 1
	expect "Please input trigger directory*"
	send "$wdDir/trgdir\r"
	sleep 1
	expect "Please input job class directory*"
	send "$wdDir/clsdir\r"
	sleep 1
	expect "Please input job instance directory*"
	send "$wdDir/instdir\r"
	sleep 1
	expect "Please input database server user name*"
	send "test_user\r"
	sleep 1
	expect "Please input database server password*"
	send "test_passwd\r"
	sleep 1
	expect "Please input mail send data policy*"
	send "test_mail_policy@hotmail.com\r"
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
echo "** Check configuration file ( default.params )"
if [ -d $wdDir ];then
	echo "** Netty port: "
	nettyPort=$( cat $wdDir/etc/system.properties | grep netty.port= )
	if [[ $nettyPort =~ .*'13112'.* ]] ; then
		echo $nettyPort : PASSED
	else
		echo $nettyPort : FAILED
		exit
	fi

	echo "** Restful server port: "
	restPort=$( cat $wdDir/etc/system.properties | grep rest.port= )
	if [[ $restPort =~ .*'8888'.* ]] ; then
		echo $restPort : PASSED
	else
		echo $restPort : FAILED
		exit
	fi
	echo "** Job directory: "
	jobDir=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.directory.job= )
	if [[ $jobDir =~ .*${wdDir}/jobdir.* ]] ; then
		echo $jobDir : PASSED
	else
		echo $jobDir : FAILED
		exit
	fi	

	echo "** Trigger directory: "
	trgDir=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.directory.trigger= )
	if [[ $trgDir =~ .*${wdDir}/trgdir.* ]] ; then
		echo $trgDir : PASSED
	else
		echo $trgDir : FAILED
		exit
	fi
	
	echo "** Jobclass directory: "
	jobClsDir=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.directory.jobcls= )
	if [[ $jobClsDir =~ .*${wdDir}/clsdir.* ]] ; then
		echo $jobClsDir : PASSED
	else
		echo $jobClsDir : FAILED
		exit
	fi	

	echo "** Instances directory: "
	instDir=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.directory.instances= )
	if [[ $instDir =~ .*${wdDir}/instdir.* ]] ; then
		echo $instDir : PASSED
	else
		echo $instDir : FAILED
		exit
	fi	

	echo "** MongoDB server host: "
	mongoHost=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mongodb.host= )
	if [[ $mongoHost =~ .*'10.0.1.111'.* ]] ; then
		echo $mongoHost : PASSED
	else
		echo $mongoHost : FAILED
		exit
	fi

	echo "** MongoDB server port: "
	mongoPort=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mongodb.port= )
	if [[ $mongoPort =~ .*'27018'.* ]] ; then
		echo $mongoPort : PASSED
	else
		echo $mongoPort : FAILED
		exit
	fi

	echo "** MongoDB database name: "
	mongoDBName=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mongodb.dbName= )
	if [[ $mongoDBName =~ .*'wiperdog_test'.* ]] ; then
		echo $mongoDBName : PASSED
	else
		echo $mongoDBName : FAILED
		exit
	fi	

	echo "** MongoDB user name: "
	mongoUser=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mongodb.user= )
	if [[ $mongoUser =~ .*'test_user'.* ]] ; then
		echo $mongoUser : PASSED
	else
		echo $mongoUser : FAILED
		exit
	fi

	echo "** MongoDB password: "
	mongoPasswd=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mongodb.pass= )
	if [[ $mongoPasswd =~ .*'test_passwd'.* ]] ; then
		echo $mongoPasswd : PASSED
	else
		echo $mongoPasswd : FAILED
		exit
	fi

	echo "** Policy Email: "
	email=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mail.toMail= )
	if [[ $email =~ .*'test_mail_policy@hotmail.com'.* ]] ; then
		echo $email : PASSED
	else
		echo $email : FAILED
		exit
	fi
	echo "===========> Case 3 : PASSED"
else
	echo "===========> Case 3 : FAILED "
	echo "Wiperdog directory not found after install !"
	exit
fi