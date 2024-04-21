local framework = include("OperatorJack.MagickaExpanded.magickaExpanded")

require("BeefStranger.Magical Repairing.repairOnTargetEffect")
require("BeefStranger.Magical Repairing.repairArmorEffect")
require("BeefStranger.Magical Repairing.repairWeaponEffect")


-- The function to call on the initialized event.
local function initialized() -- 1.
  -- Print a "Ready!" statement to the MWSE.log file.
  print("[MWSE:Magical Repairing") --2.
end

-- Register our initialized function to the initialized event.

local spellIds = {
  bsRepairTarget = "bsRepairTarget",
  bsRepairArmor = "bsRepairArmor",
  bsRepairWeapon = "bsRepairWeapon"
}
--TODO: make magnitude determine how much. --Cant figure out how to get magnitude :(
local function registerSpells()
  framework.spells.createBasicSpell({
    id = spellIds.bsRepairTarget,
    name = "Repair Target",
    effect = tes3.effect.bsRepairTarget,
    range = tes3.effectRange["target"],
    min = 50,
    max = 50
  })
  framework.spells.createBasicSpell({
    id = spellIds.bsRepairArmor,
    name = "Repair Armor",
    effect = tes3.effect.bsRepairArmor,
    range = tes3.effectRange["self"],
    min = 50,
    max = 50,
    duration = 0
  })
  framework.spells.createBasicSpell({
    id = spellIds.bsRepairWeapon,
    name = "Repair Weapon",
    effect = tes3.effect.bsRepairWeapon,
    range = tes3.effectRange["self"],
    min = 50,
    max = 50,
    duration = 0
  })
end

local function addSpells()
  -- local wasAdded = nil
  -- if (wasAdded == nil) then
  local wasAdded = tes3.addSpell({ reference = "orrent geontene", spell = "bsRepairTarget" })
  local wasAdded = tes3.addSpell({ reference = "orrent geontene", spell = "bsRepairArmor" })
  local wasAdded = tes3.addSpell({ reference = "orrent geontene", spell = "bsRepairWeapon" })
  -- end
end



----=========MCM config load/Defaults============
local config = mwse.loadConfig("Magical Repairing", {
  xpGain = false,
  debugMode = false,
})

---========MCM Page Creation=============
local function registerModConfig()
  local template = mwse.mcm.createTemplate("Magical Repairing")
  template:saveOnClose("Magical Repairing", config)
  template:register()

  local page = template:createSideBarPage({ label = "Magical Repairing Config Menu" })

  local xpToggle = page:createCategory("Xp Gain from Spells")
  xpToggle:createYesNoButton({
    label = "Enable/Disable Xp Gain",
    variable = mwse.mcm.createTableVariable({ id = "xpGain", table = config })
  })
  local debug = page:createCategory("Enable Debug Mode")
  debug:createYesNoButton({
    label = "Debug Mode",
    variable = mwse.mcm.createTableVariable({ id = "debugMode", table = config })
  })
end

---======DEBUG===========
local function onKeyDownQuote()
  if not tes3.menuMode() then
    if config.debugMode == true then
      local vector = tes3vector3.new(-848, -17, -126)
      tes3.positionCell({ reference = tes3.player, position = vector, cell = "Ald-Ruhn, Guild of Mages" })
      tes3.removeSpell({ reference = "orrent geontene", spell = "bsRepairTarget" })
      tes3.removeSpell({ reference = "orrent geontene", spell = "bsRepairArmor" })
      tes3.removeSpell({ reference = "orrent geontene", spell = "bsRepairWeapon" })
      tes3.messageBox("Removing Spells")
    end
  end
end

local function onKeyDownQuestion()

end

event.register(tes3.event.keyDown, onKeyDownQuote, { filter = tes3.scanCode.singleQuote })
event.register(tes3.event.keyDown, onKeyDownQuestion, { filter = tes3.scanCode.questionMark })
---===============================================================================================

event.register("modConfigReady", registerModConfig)

event.register(tes3.event.loaded, addSpells)
event.register("MagickaExpanded:Register", registerSpells)
event.register(tes3.event.initialized, initialized) --3.
