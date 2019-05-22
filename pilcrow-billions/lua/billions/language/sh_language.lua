PW_Billions = PW_Billions or {}

function PW_Billions.getPhrase(name)
  if PW_Billions.LANGUAGE[name] then
    return PW_Billions.LANGUAGE[name]
  else
    return "LANG_ERROR"
  end
end
