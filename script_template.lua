AVATARMODIFIER = '0.43F;20F;20F;1F;1;0~48:160'
RAPIDFIRE = '1F;1F;1;444,444::80'
CUBERAPIDREMOVE = '1F;1F;1F;0.3F;1;0.8F;444,444;1::160'
VNOCLIP = '1D;0;0.95;0.45::25'
AVATARIMPULSE = '5;90;20;1D;1;1::90'
AVATARRADIUS = '0.45;0.95::80'
AVATARHITBOX = '1;0.00999999978;267D;0.4~0.6;0.3~1'
IMPULSEREVERSE = '3000;1500;1600::'
IMPULSERANGE = '1500;1600;25'
PLAYERSWIMMING = '10;4;0.6::'
AFK_ACTIVATION = '590000000;1::'
INFOXYGEN = '258,000~265,000D;1;20;20::100'
THEMECLIMATE = '13;0.1~100;1;12.5;4D::'
ANDROIDRESOLUTION = '1D;100;1;1000~3000;96::60'

INF = '3.4E38'

function saveHackResult(result_name, results)
	gg.toast('Actived '..result_name)
	local edited_results = {}
	
	for i, result in ipairs(results) do
		table.insert(edited_results, {
			name=result.name, 
			value=result.value, 
			flags=result.flags,
			address=result.address
		})
    end

    gg.addListItems(new_results)
end

function scanNumber(values, value_type, refine_value, refine_value_type)
	gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
	gg.searchNumber(value, value_type)
	
	refine_value_type = refine_value_type or gg.TYPE_AUTO
	if refine_value ~= nil then
		gg.refineNumber(refine_value, refine_value_type)
    end

	return gg.getResults(getResultsCount())
end

function getParameterValueType(rType)
    if rType == 'float' then
        return gg.TYPE_FLOAT
    elseif rType == 'dword' then
        return gg.TYPE_DWORD
    end
    return gg.TYPE_AUTO
end

function editSpecificResult(result_name, change_value, value_type, only_get)
    value_type = getParameterValueType(value_type)

    local saved_results = gg.getListItems()
    local specific_results = {}

    local function LoadResult(results)
        gg.clearResults()
        gg.loadResults(results)
        return gg.getResults(gg.getResultsCount())
    end

    for _, result in ipairs(saved_results) do
        if result.name == result_name then
            table.insert(specific_results, {
                name=result.name,
                value=result.value,
                flags=result.flags,
                address=result.address
            })
        end
    end

    if #specific_results > 0 then
        _results = LoadResult(specific_results)
        if only_get then return _results end

        gg.editAll(change_value, value_type)
        gg.toast('Desactived/Changed: '..result_name)
    else
        if only_get then return {} end
    end
end

function isResultSaved(result_name)
    if #editSpecificResult(result_name, nil, 'auto', true) > 0 then
        return true
    end
    return false
end


function setAvatarModifier(modifier_id)
    modifier_id = modifier_id or '0'
    
    if not isResultSaved() then
        results = scanNumber(AVATARMODIFIER, gg.TYPE_DWORD, '1', gg.TYPE_DWORD)

        gg.editAll(tostring(modifier_id), gg.TYPE_DWORD)
        saveHackResult('Avatar Modifier', results)
    else
        editSpecificResult('Avatar Modifier', modifier_id, gg.TYPE_DWORD)
    end
end

function RapidFireWeapons()
    results = scanNumber(RAPIDFIRE, gg.TYPE_DWORD, '1', gg.TYPE_DWORD)

    gg.editAll('0', gg.TYPE_DWORD)
    saveHackResult('RapidFire-Weapons', results)
end

function CubeGunRapidFire()
    results = scanNumber(CUBERAPIDREMOVE, gg.TYPE_DWORD, '1', gg.TYPE_DWORD)

    gg.editAll('0', gg.TYPE_DWORD)
    saveHackResult('CubeGun Rapid Remove', results)
end

function AvatarNoclip()
    results = scanNumber(VNOCLIP, gg.TYPE_FLOAT, '0', gg.TYPE_FLOAT)

    gg.editAll('0', gg.TYPE_FLOAT)
    saveHackResult('Noclip', results)
end

function AvatarNoImpulse()
    results = scanNumber(AVATARIMPULSE, gg.TYPE_FLOAT, '1', gg.TYPE_FLOAT)

    gg.editAll(INF, gg.TYPE_FLOAT)
    saveHackResult('No Impulse', results)
end

function SimpleAvatarRadius()
    local radius = gg.prompt({'Radius (max: 3 by anti cheat)'}, {'number'}, {0.45})

    if radius[1] > 3 or radius < 0.05 then
        radius[1] = 0.45 -- reset
    end

    if isSavedResult('Avatar Radius') then
        editSpecificResult('Avatar Radius', radius[1], gg.TYPE_FLOAT)
        return
    end

    results = scanNumber(AVATARRADIUS, gg.TYPE_FLOAT, '0.45;0.95', gg.TYPE_FLOAT)

    gg.editAll(radius[1], gg.TYPE_FLOAT)
    saveHackResult('Avatar Radius', results)
end

function AvatarHitBoxRange()
    local range = gg.prompt({'Range'}, {'number'}, {0.5})

    if isSavedResult('Avatar HitBox') then
        editSpecificResult('Avatar HitBox', range[1], gg.TYPE_FLOAT)
        return
    end

    results = scanNumber(AVATARHITBOX, gg.TYPE_FLOAT, '0.45;0.95', gg.TYPE_FLOAT)

    gg.editAll(range[1], gg.TYPE_FLOAT)
    saveHackResult('Avatar HitBox', results)
end

function ImpulseGunReverse()
    results = scanNumber(IMPULSEREVERSE, gg.TYPE_FLOAT, '3000', gg.TYPE_FLOAT)

    gg.editAll('-4000', gg.TYPE_FLOAT)
    saveHackResult('Impulse Gun Reverse', results)
end

function ImpulseGunRange()
    results = scanNumber(IMPULSERANGE, gg.TYPE_FLOAT, '25', gg.TYPE_FLOAT)

    gg.editAll(INF, gg.TYPE_FLOAT)
    saveHackResult('Impulse Gun Range', results)
end

function SwimmingExecution()
    results = scanNumber(PLAYERSWIMMING, gg.TYPE_FLOAT, '0.6', gg.TYPE_FLOAT)

    gg.editAll(INF, gg.TYPE_FLOAT)
    saveHackResult('Swimming', results)
end

function AntiAFK()
    results = scanNumber(AFK_ACTIVATION, gg.TYPE_DWORD, '1', gg.TYPE_DWORD)

    gg.editAll('0', gg.TYPE_FLOAT)
    saveHackResult('Anti AFK', results)
end

function InfiniteOxygen()
    results = scanNumber(INFOXYGEN, gg.TYPE_FLOAT, '20', gg.TYPE_FLOAT)

    gg.editAll(INF, gg.TYPE_FLOAT)
    saveHackResult('Infinite Oxygen', results)
end

function ClimateChanger()
    local climate = gg.prompt({'Climate Value [0; 100]'}, {'number'}, {20})

    if isSavedResult('Climate') then
        editSpecificResult('Climate', climate[1], gg.TYPE_FLOAT)
        return
    end

    results = scanNumber(THEMECLIMATE, gg.TYPE_FLOAT, '0.01~100', gg.TYPE_FLOAT)

    gg.editAll(climate[1], gg.TYPE_FLOAT)
    saveHackResult('Climate', results)
end

function GameResolution(resolution)
    if isSavedResult('Resolution') then
        editSpecificResult('Resolution', resolution, gg.TYPE_FLOAT)
        return
    end

    results = scanNumber(ANDROIDRESULUTION, gg.TYPE_FLOAT, '1000~3000', gg.TYPE_FLOAT)

    gg.editAll(resolution, gg.TYPE_FLOAT)
    saveHackResult('Resolution', results)
end
        
func_hack_options1 = {
    AvatarModifier = 'Avatar Modifier',
    InfiniteHealth = 'INF. Health',
    setInvisibility = 'Invisibility',
    setAvatarModifier = 'No Block - Damage',
    AvatarNoclip = 'Noclip',
    AvatarNoImpulse = 'No Impulse',
    SimpleAvatarRadius = 'Avatar Radius - Simple',
    AvatarHitBoxRange = 'Avatar HitBox - Range'
}
func_hack_options2 = {
    ImpulseKick = 'Impulse Kick',
    RapidFireWeapons = 'RapidFire - Weapons',
    CubeGunRapidFire = 'Cube Gun - Rapid Fire',
    ImpulseGunRange = 'Impulse Gun - Range',
    ImpulseGunReverse = 'Impulse Gun - Reverse'
}
func_hack_options3 = {
    SwimmingExecution = 'Always Swimming',
    AntiAFK = 'Anti AFK',
    InfiniteOxygen = 'INF. Oxygen',
    ClimateModifier = 'Theme - Climate Modifier',
    GameResolution = 'Resolution Changer'
}
func_resolutions_options = {
    r720_480 = '720×480 (SD)',
	r960_540 = '960×540 (qHD)',
	r1024_576 = '1024×576',
	r1152_648 = '1152×648',
	r1280_720 = '1280×720 (HD)',
	r1366_768 = '1366×768 (WXGA)',
	r1920_1080 = '1920×1080 (FHD)',
	r2560_1440 = '2560×1440 (QHD)',
	r3840_2160 = '3840×2160 (4K UHD)',
	UPDATER1 = 'Custom Resolution',
	UPDATER2 = 'Custom Resolution  (simple)'
}

function ScriptsFunctionExecutor(funcOptions)
    local option_number = 0
    local options = gg.multiChoice(funcOptions)

    for execute_func, option_name in pairs(funcOptions) do
        print(execute_func, option_name)
        option_number = option_number + 1
        if options[option_number] == true then execute_func() end
    end
end

ScriptsFunctionExecutor(func_hack_options1)
