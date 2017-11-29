TANKS  = [];

if (NUMBER_TANKS == 0)exitWith{TANKS};

_worldSize = if (isNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize")) then {getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");} else {8192;};
_worldCenter = [_worldSize/2,_worldSize/2,0];

while {count TANKS < NUMBER_TANKS} do{

     _spawnPos = [_worldCenter, (_worldSize/2)*0.8, (_worldSize/2), 5, 0, 20, 0, MARKER_WHITE_LIST] call BIS_fnc_findSafePos;

    _className = (ENEMY_LIST_TANKS call bis_fnc_selectrandom);
    _tank = [[_spawnPos select 0, _spawnPos select 1, 50], 180, _className, ENEMY_SIDE] call BIS_fnc_spawnVehicle select 0;

    _tank setPilotLight true;
    _tank setCollisionLight true;
    group _tank setBehaviour "SAFE";
    driver _tank setBehaviour "SAFE";

    if (DEBUG) then {
        private _marker = createMarker [format["tk-%1",random 10000],_spawnPos];
        _marker setMarkerShape "ICON";
        _marker setMarkerColor "ColorRed";
        _marker setMarkerType "o_armor";
        _tank setVariable["marker",_marker];
    };

    _tank setVariable ["IH_type","tank"];
    _tank setVariable ["IH_isIntel",true];

    _tank addEventHandler ["Killed",{
         params["_tank","_killer"];
         if (_killer in units (group player)) then {
            //Task success
            _tank call fnc_success;
         };
    }];
    
    TANKS pushback _tank;
};

TANKS;