function PW_Billions.isItemValid(className)
  if PW_Billions.PC_BUYITEMS[className] or PW_Billions.CRAFTABLE.WORKBENCH[className] then
    return true
  end
  return false
end
