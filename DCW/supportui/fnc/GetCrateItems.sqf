
if (count GEAR_AND_STUFF == 0) then {
  GEAR_AND_STUFF = [];
  _gearAndStuffArray = [];
  { 
    _items =  getUnitLoadout _x;
    if (count _items > 0) then { 
    { 
      if (typeName _x == "ARRAY" ) then { 
        if (count _x > 0) then { 
          {
            if (typeName _x == "STRING") then {
              if (_x != "") then { _gearAndStuffArray pushBackUnique _x;  };
            } else{
              if (typeName _x == "ARRAY" ) then { 
                  if (count _x > 0) then { 
                    {
                      if (typeName _x == "STRING" ) then {
                        if (_x != "") then { _gearAndStuffArray pushBackUnique _x;  };
                      };
                    }foreach _x;
                  }; 
                };
            };
          } foreach _x;
        }; 
      } else { 
        if (typeName _x == "STRING") then {
          if (_x != "") then { _gearAndStuffArray pushBackUnique _x;  };
        };
      }; 
      } foreach _items; 
    }; 
  } foreach FRIENDLY_LIST_UNITS;

  _output = [];
  _weapons = configFile >> "CfgWeapons";

  for "_i" from 1 to ((count _weapons) - 1) do 
  {
    _weapon = _weapons select _i;

    if (isClass _weapon && (configName _weapon) isKindOf "Backpacks" ) then 
    {
      GEAR_AND_STUFF pushback (configName _weapon);
    };
  };
  _output;

  GEAR_AND_STUFF = _gearAndStuffArray;
};

GEAR_AND_STUFF;