#!/bin/bash


while getopts ":m:f:d:R:t:h" opt;
do
	case ${opt} in
		h)
			echo "Usage: ./secure_copy_remote.sh [options...]"
			echo "	-h  help"
			echo "	-m  [to/from] remote pc"
			echo "	-f  file path"
			echo "	-t  f/d (file/directory copying)"
			echo "	-d  destination folder"
			echo "	-R  remote pc e.g host_name@192.168.11.5"
			exit 0
			;;
		f)
			FILE=${OPTARG};;
		m)
			MODE=${OPTARG};;
		d)
			DESTINATION=${OPTARG};;
		R)
			REMOTE_PC=${OPTARG};;
		t)
			COPY_TYPE=${OPTARG};;

		/?)
			echo "Invalid option ${OPTARG}. Check usage below:"
			./secure_copy_remote.sh -h
			exit 1
			;;
	esac
done

if [[ -z ${MODE} || -z ${FILE} || -z ${DESTINATION} || -z ${REMOTE_PC} || -z ${COPY_TYPE} ]];
then
	echo "Please enter required arguments. Check usage below:"
	./secure_copy_remote.sh -h
	exit 1
fi

if [ ${MODE} = "to" ];
then
	echo "Copying to remote pc...

	"
	read -t 2 -p "Now copying ${FILE} to ${REMOTE_PC}:/${DESTINATION}"
	echo "
	Enter remote login password
	"
	if [ ${COPY_TYPE} = "f" ];
	then
		scp ${FILE} "${REMOTE_PC}:/${DESTINATION}"
	else
		scp -r ${FILE} "${REMOTE_PC}:/${DESTINATION}"
	fi
	echo "
	File transfer completed"

elif [ ${MODE} = "from" ];
then
	echo "Copying to remote pc...

	"
	read -t 2 -p "Now copying ${FILE} from ${REMOTE_PC} to ${DESTINATION}"
	echo "
	Enter remote login password
	"
	if [ ${COPY_TYPE} = "f" ];
	then
		scp  "${REMOTE_PC}:/${FILE}" ${DESTINATION}
	else
		scp -r  "${REMOTE_PC}:/${FILE}" ${DESTINATION}
	fi

	echo "
	File transfer completed"
fi

