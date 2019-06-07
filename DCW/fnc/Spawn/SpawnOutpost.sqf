/**
 * DYNAMIC CIVIL WAR
 * Created: 2017-11-29
 * Author: BIDASS
 * License : GNU (GPL)
 */

private ["_pos","_radius","_nicePos","_enemy","_grp"];

params["_marker","_nb"];
private _units = [];
if (_nb == 0)exitWith {_units};

_pos = getmarkerpos _marker;
_radius = ((getMarkerSize _marker) select 0);

 for "_xc" from 1 to _nb do {
     
    _nicePos = [_pos, _radius, (_radius + 100), 2, 0,.2, 0,MARKER_WHITE_LIST] call BIS_fnc_findSafePos;
    if (isNil "_nicePos")exitWith{[]};
    if (isOnRoad _nicePos)exitWith{[]};

    _newObjs = [_nicePos,random 360, compos call bis_fnc_selectrandom] call BIS_fnc_ObjectsMapper;

    private _objBase = (_newObjs select 0);

    [_objBase, "ColorOrange"] call fnc_addMarker;
    _objBase setVariable["DCW_IsIntel",true];
    _objBase setVariable["DCW_Type","outpost"];
    _soldiers = [];
    _nbUnit = ceil (random 3);
    for "_xc" from 1 to _nbUnit do {
        _grp = createGroup SIDE_ENEMY;
        _enemy = [_grp,_nicePos,false] call fnc_spawnEnemy;
        _enemy setDir random 360;

        //Add torch to soldiers
        [_enemy,10] spawn fnc_simplepatrol;

        _soldiers pushback _enemy;
        _newObjs pushback _enemy;
    };

    // Add action to dismantle camp
    [ _objBase,"Secure and search intel","\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa","\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa","true","true",{
        (_this select 1) playActionNow "medic";
    },{},{
    _objBase = (_this select 0);
    _newObjs = (_this  select 3) select 0;
    [_objBase, _this select 1]  remoteExec ["fnc_GetIntel",2];

    {
        if (alive _x )then{
            _x setDamage 1;
        };
    }foreach _newObjs;
    
    _objBase remoteExec ["fnc_success",2,false];
    },{},[_newObjs],3,nil,true,false] remoteExec ["BIS_fnc_holdActionAdd"];

    _units = _units + _newObjs;
 };

_units;