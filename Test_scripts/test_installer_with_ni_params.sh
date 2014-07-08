 #!/bin/bash
if [ "$#" == 0 ];then
	echo "Incorrect script parameters"
	echo "Usage: ./test_installer_multiple_params.sh path/to/wiperdog_installer_jar"
	echo "Example : ./test_installer_multiple_params.sh wiperdog-0.2.5-SNAPSHOT-unix.jar"
	exit
fi
 wdInstaller=$1
 baseDir=$(pwd)
 wdDir=$baseDir/wiperdog-0.2.5-SNAPSHOT
echo "==============TEST Wiperdog installer=================="
echo "--Test wiperdog installer after updating user input to default params & move Restful port to configuration file--"
echo "-----------------------------------------------------------------------------------------"
echo "Case 1 : Install with only '-ni' param"
echo "** Clean data..."
sudo rm -rf $wdDir
if [ -d $wdDir ]; then
	echo "Failure to clean data .."
	exit
fi
echo "** Install wiperdog..."
echo "** command : java -jar $wdInstaller -ni"
java -jar $wdInstaller -d $wdDir -ni
sleep 5
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

	echo "** Resful server port: "
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
	mongoUser=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mongodb.user= )
	if [[ $mongoUser =~ .*''.* ]] ; then
		echo $mongoUser : PASSED
	else
		echo $mongoUser : FAILED
		exit
	fi

	echo "** MongoDB password: "
	mongoPasswd=$( cat $wdDir/etc/monitorjobfw.cfg | grep monitorjobfw.mongodb.pass= )
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
	echo "===========> Case 1 : FAILED"
	echo "Wiperdog directory not found after install !"
	exit
fi
sleep 10
echo "Case 2 : Install with '-ni' param and others"
echo "** Clean data..."
sudo rm -rf $wdDir
if [ -d $wdDir ]; then
	echo "Failure to clean data .."
	exit
fi
echo "** Install wiperdog..."
echo "** command : java -jar $wdInstaller -ni -d $wdDir -r 8888 -m 10.0.1.111 -p 27018 -n wiperdog_test -u test_user -pw test_passwd -s no"
java -jar $wdInstaller -ni -d $wdDir -r 8888 -m 10.0.1.111 -p 27018 -n wiperdog_test -u test_user -pw test_passwd -s no
sleep 5
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

	echo "** Resful server port: "
	restPort=$( cat $wdDir/etc/system.properties | grep rest.port= )
	if [[ $restPort =~ .*'8888'.* ]] ; then
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
	if [[ $email =~ .*'testmail@gmail.com'.* ]] ; then
		echo $email : PASSED
	else
		echo $email : FAILED
		exit
	fi
	echo "===========> Case 2 : PASSED"
else
	echo "===========> Case 2 : FAILED"
	echo "Wiperdog directory not found after install !"
	exit
fi
