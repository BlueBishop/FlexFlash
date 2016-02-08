﻿//The system for rolling a monster encounter, as well as facilitating a manual encounter



function wardingOn():Boolean {
	if(getStat("maleward") == 1 || getStat("femaleward") == 1 || getStat("hermward") == 1 || getStat("furryward") == 1 || getStat("feralward") == 1 || getStat("horrorward") == 1 || getStat("humanward") == 1 || getStat("sillyward") == 1) return(true);
	else return(false);
}

function isWarded(str:String):Boolean {
	var arr:Array = str.split("/");
	var arrayLength:Number = arr.length;
	var tempnum:Number = 0;
	for(tempnum = 0; tempnum < arrayLength; tempnum++) {
		if((getStat("furryward") == 1 && arr[tempnum] == "furry") || (getStat("feralward") == 1 && arr[tempnum] == "feral") || (getStat("humanward") == 1 && arr[tempnum] == "human") || (getStat("sillyward") == 1 && arr[tempnum] == "silly") || (getStat("horrorward") == 1 && arr[tempnum] == "horror") || (getStat("maleward") == 1 && arr[tempnum] == "male") || (getStat("femaleward") == 1 && arr[tempnum] == "female") || (getStat("hermward") == 1 && arr[tempnum] == "herm")) return(true);
	}
	return(false);
}

function encounter(zone:String): void {
	var arr:Array = [];
	var sumWeight:Number = 0;
	var tempnum:Number = 0;
	var pulledTable:Array = [];
	var arrayLength:Number = worldMaster["Monsters"].length;
	var noctVar:Number = 0;
	if(wardingOn()) {
		for(tempnum = 0; tempnum < arrayLength; tempnum++) {
			if(worldMaster["Monsters"][tempnum][2] == zone && worldMaster["Monsters"][tempnum][0] <= getStat("level") && isWarded(worldMaster["Monsters"][tempnum][6]) == false) {
				noctVar = 0;
				pulledTable.push(worldMaster["Monsters"][tempnum]);
				arr = worldMaster["Monsters"][tempnum][5].split("/");
				if(getStat("World Time") < 61 || getStat("World Time") > 1380) noctVar = arr[1]/2;
				else if(getStat("World Time") < 781 && getStat("World Time") > 660) noctVar = (-1*(arr[1]))/2;
				else if(getStat("World Time") < 721 ) noctVar = -1*(arr[1]);
				else noctVar = arr[1];
				//trace("Monster " + worldMaster["Monsters"][tempnum][1] + " weight: " + (arr[0]-noctVar));
				if(arr[0]-noctVar > 0) sumWeight += arr[0]-noctVar;
			}
		}
	}
	if(!wardingOn() || sumWeight == 0) {
		for(tempnum = 0; tempnum < arrayLength; tempnum++) {
			if(worldMaster["Monsters"][tempnum][2] == zone && worldMaster["Monsters"][tempnum][0] <= getStat("level")) {
				noctVar = 0;
				pulledTable.push(worldMaster["Monsters"][tempnum]);
				arr = worldMaster["Monsters"][tempnum][5].split("/");
				if(getStat("World Time") < 61 || getStat("World Time") > 1380) noctVar = arr[1]/2;
				else if(getStat("World Time") < 781 && getStat("World Time") > 660) noctVar = (-1*(arr[1]))/2;
				else if(getStat("World Time") < 721 ) noctVar = -1*(arr[1]);
				else noctVar = arr[1];
				//trace("Monster " + worldMaster["Monsters"][tempnum][1] + " weight: " + (arr[0]-noctVar));
				if(arr[0]-noctVar > 0) sumWeight += arr[0]-noctVar;
			}
		}
	}
	arrayLength = pulledTable.length;
	var modWeight:Number = 0;
	if(sumWeight > 0) {
		modWeight = sumWeight;
		for(tempnum = 0; tempnum < arrayLength; tempnum++) {
			arr = pulledTable[tempnum][5].split("/");
			noctVar = 0;
			if(getStat("World Time") < 61 || getStat("World Time") > 1380) noctVar = arr[1]/2;
			else if(getStat("World Time") < 781 && getStat("World Time") > 660) noctVar = (-1*(arr[1]))/2;
			else if(getStat("World Time") < 721 ) noctVar = -1*(arr[1]);
			else noctVar = arr[1];
			if(Math.random()*modWeight < arr[0] - noctVar) {
				inCombat = true;
				this[pulledTable[tempnum][3]]();
				this[pulledTable[tempnum][4]]();
				if(hasTarget(pulledTable[tempnum][1]) == false) addTarget(pulledTable[tempnum][1], pulledTable[tempnum][1], pulledTable[tempnum][2], 1);
				say("\r\r");
				enemyentry();
				setStat("enemyhealth", getStat("enemymaxhealth"));
				setStat("enemylevel", pulledTable[tempnum][0]);
				doNext("3", doCombatEvent);
				tempnum = arrayLength;
			}
			else if(arr[0]-noctVar > 0) modWeight -= arr[0] - noctVar
		}
	}
	else {
		say("\r\r...But Nobody Came...\r\r");
		doNext("", doLastRoom);
	}
}

function challenge(str:String): void {
	inCombat = true;
	var tempnum:Number = 0;
	var arrayLength:Number = worldMaster["Monsters"].length;
	for(tempnum = 0; tempnum < arrayLength; tempnum++) {
		if(worldMaster["Monsters"][tempnum][1] == str) {
			this[worldMaster["Monsters"][tempnum][3]]();
			this[worldMaster["Monsters"][tempnum][4]]();
			if(hasTarget(worldMaster["Monsters"][tempnum][1]) == false) addTarget(worldMaster["Monsters"][tempnum][1], worldMaster["Monsters"][tempnum][1], worldMaster["Monsters"][tempnum][2], 1);
			enemyentry();
			setStat("enemyhealth", getStat("enemymaxhealth"));
			setStat("enemylevel", worldMaster["Monsters"][tempnum][0]);
			doNext("3", doCombatEvent);
			return;
		}
	}
}