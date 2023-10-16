#!/bin/bash
################################################################################
# Author: Fred (support@qo-op.com)
# Version: 0.2
# License: AGPL-3.0 (https://choosealicense.com/licenses/agpl-3.0/)
################################################################################
MY_PATH="`dirname \"$0\"`"              # relative
MY_PATH="`( cd \"$MY_PATH\" && pwd )`"  # absolutized and normalized
. "$MY_PATH/../tools/my.sh"
################################################################################
## MAP REFRESH
# LOAD EXTRA DATA TO CACHE ~/.zen/tmp/${IPFSNODEID}/
# PUBLISH STATION BALISE
############################################
echo "## RUNNING NODE.refresh"
[[ ${IPFSNODEID} == "" ]] && echo "IPFSNODEID is empty - EXIT -" && exit 1

#################################################################
## IPFSNODEID ASTRONAUTES SIGNALING ## 12345 port
############################

# UDATE STATION BALISE
if [[ -d ~/.zen/tmp/${IPFSNODEID} ]]; then

    # ONLY FRESH DATA HERE
    BSIZE=$(du -b ~/.zen/tmp/${IPFSNODEID} | tail -n 1 | cut -f 1)
    ## Getting actual online version
    #~ ipfs get -o ~/.zen/tmp/${IPFSNODEID} /ipns/${IPFSNODEID}/

    ## COPY STATION  yt-dlp.list
    cp $HOME/.zen/.yt-dlp.list ~/.zen/tmp/${IPFSNODEID}/yt-dlp.list

    ## COPY COINS VALUE OF THE DAY
    mkdir -p ~/.zen/tmp/${IPFSNODEID}/COINS/
    cp -f ~/.zen/tmp/coucou/*.COINS ~/.zen/tmp/${IPFSNODEID}/COINS/

    ## COPY FRIENDS
    PLAYERONE=($(ls -t ~/.zen/game/players/  | grep "@" 2>/dev/null))
    echo "FOUND : ${PLAYERONE[@]}"
    ## RUNING FOR ALL LOCAL PLAYERS
    for PLAYER in ${PLAYERONE[@]}; do
        echo "${PLAYER} SEEKING OWN FRIENDS"
        mkdir -p ~/.zen/tmp/${IPFSNODEID}/${PLAYER}/FRIENDS/
        cp -Rf ~/.zen/game/players/${PLAYER}/FRIENDS/* ~/.zen/tmp/${IPFSNODEID}/${PLAYER}/FRIENDS/
    done

    cp ~/.zen/GPS ~/.zen/tmp/${IPFSNODEID}/
    echo "############################################ MY MAP "
    ls ~/.zen/tmp/${IPFSNODEID}/
    echo "############################################"
    NSIZE=$(du -b ~/.zen/tmp/${IPFSNODEID} | tail -n 1 | cut -f 1)
    ROUTING=$(ipfs add -rwHq ~/.zen/tmp/${IPFSNODEID}/* | tail -n 1 )
    ipfs name publish /ipfs/${ROUTING}
    echo ">> $NSIZE Bytes STATION BALISE > ${myIPFS}/ipns/${IPFSNODEID}"

fi

exit 0