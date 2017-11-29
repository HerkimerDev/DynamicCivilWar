private["_grp"];
//Carry script
//Credits to Psycho


_grp = _this select 0;
_deaths = _this select 1;
_helo = _this select 2;
_nbUnitSaved = 0;

_leader =  leader _grp;
_assistant = (units _grp) select 1;
_leader setIdentity "CSAR Leader";
_assistant setIdentity "CSAR Operator";
_grp setBehaviour "CARELESS";

{
	_target = _x;
	[_leader,_assistant,_target,_helo] call fnc_help;
	waitUntil{ !alive _leader || !alive _assistant || !alive _target || {_target getVariable["unit_stabilized",false]}};
	if (!alive _leader || !alive _assistant) exitWith{[_helo] call fnc_abortMedevac;};
	_nbUnitSaved = _nbUnitSaved + 1;
}forEach _deaths;

waitUntil{_nbUnitSaved == count _deaths};

_deaths joinSilent _grp;
{unassignVehicle _x} forEach units _grp;
{
	_x assignAsCargoIndex [_helo, _forEachIndex];
} foreach  units _grp;
(units _grp) orderGetIn true;


true;