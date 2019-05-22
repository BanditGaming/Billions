hook.Add("DarkRPDBInitialized", "loadBillionsFromDB", function()
  print("Billions: Setting up the database")
  if MySQLite.isMySQL() then
    MySQLite.begin()
    MySQLite.queueQuery("CREATE TABLE IF NOT EXISTS `pilcrow_billions_blueprints` (`className`	varchar ( 50 ),  PRIMARY KEY(`className`))")
    --Table with company data: ownerSid64, name, wallet
    MySQLite.queueQuery("CREATE TABLE IF NOT EXISTS `pilcrow_billions_business` (`ownerSid64`	bigint ( 20 ) NOT NULL UNIQUE, `name`	varchar ( 25 ) NOT NULL, `wallet`	int ( 11 ) NOT NULL DEFAULT 0, `level`	int ( 11 ) NOT NULL DEFAULT 0, `xp`	int ( 11 ) NOT NULL DEFAULT 0, `skillPoints`	int ( 11 ) NOT NULL DEFAULT 0, PRIMARY KEY(`ownerSid64`))")
    --instead of fully removing a business, it can be moved here
    MySQLite.queueQuery("CREATE TABLE IF NOT EXISTS `pilcrow_billions_businessSaved` (`ownerSid64`	bigint ( 20 ) NOT NULL UNIQUE, `level`	int ( 11 ) NOT NULL DEFAULT 0, `xp`	int ( 11 ) NOT NULL DEFAULT 0, `skillPoints`	int ( 11 ) NOT NULL DEFAULT 0, PRIMARY KEY(`ownerSid64`))")
    MySQLite.queueQuery("CREATE TABLE IF NOT EXISTS `pilcrow_billions_businessBlueprints` (`ownerSid64`	bigint ( 20 ), `className` varchar(50))")
    --Company transaction log
    MySQLite.queueQuery("CREATE TABLE IF NOT EXISTS `pilcrow_billions_businessBankLog` (`senderSid64`	bigint ( 20 ), `receiverSid64`	bigint ( 20 ), `transactionType`	int ( 11 ) NOT NULL, `amount`	int ( 11 ) NOT NULL, `title`	varchar ( 50 ), `dateTime`	datetime NOT NULL)")
    --Table with players history of employment
    MySQLite.queueQuery("CREATE TABLE IF NOT EXISTS `pilcrow_billions_employmentHistory` (`employeeID` bigint(20) NOT NULL, `ownerSid64` bigint(20) NOT NULL, `businessName` varchar(25) NOT NULL, `dateTime` datetime NOT NULL, `position` varchar(45) NOT NULL)")
    --tasks
    MySQLite.queueQuery("CREATE TABLE IF NOT EXISTS `pilcrow_billions_tasks` (`rowid` int(12) NOT NULL PRIMARY KEY AUTO_INCREMENT, `type` int(12) NOT NULL, `timeType` int(12) NOT NULL, `time` int(32) NOT NULL, `className` varchar(50) NOT NULL, `amount` int(12) NOT NULL, `money` int(12), `xp` int(12))")
    --tasks progress
    MySQLite.queueQuery("CREATE TABLE IF NOT EXISTS `pilcrow_billions_businessTasks` (`ownerSid64` bigint(20) NOT NULL, `taskID` int(12) NOT NULL, `progress` int(12) NOT NULL DEFAULT 0)")
    MySQLite.commit()

    MySQLite.begin()
    for k,v in pairs(PW_Billions.CRAFTABLE.WORKBENCH) do
      if v.needBlueprint then
        MySQLite.queueQuery("INSERT IGNORE INTO `pilcrow_billions_blueprints` (`className`) VALUES ('" .. v.class .. "')")
      end
    end
    MySQLite.commit()
  else
    MySQLite.begin()
    MySQLite.queueQuery("CREATE TABLE IF NOT EXISTS `pilcrow_billions_blueprints` (`className`	varchar ( 50 ),  PRIMARY KEY(`className`))")
    MySQLite.queueQuery("CREATE TABLE IF NOT EXISTS `pilcrow_billions_business` (`ownerSid64`	bigint ( 20 ) NOT NULL UNIQUE, `name`	varchar ( 25 ) NOT NULL, `wallet`	int ( 11 ) NOT NULL DEFAULT 0, `level`	int ( 11 ) NOT NULL DEFAULT 0, `xp`	int ( 11 ) NOT NULL DEFAULT 0, `skillPoints`	int ( 11 ) NOT NULL DEFAULT 0, PRIMARY KEY(`ownerSid64`))")
    MySQLite.queueQuery("CREATE TABLE IF NOT EXISTS `pilcrow_billions_businessSaved` (`ownerSid64`	bigint ( 20 ) NOT NULL UNIQUE, `level`	int ( 11 ) NOT NULL DEFAULT 0, `xp`	int ( 11 ) NOT NULL DEFAULT 0, `skillPoints`	int ( 11 ) NOT NULL DEFAULT 0, PRIMARY KEY(`ownerSid64`))")
    MySQLite.queueQuery("CREATE TABLE IF NOT EXISTS `pilcrow_billions_businessBlueprints` (`ownerSid64`	bigint ( 20 ), `className`	varchar(50), FOREIGN KEY(`className`) REFERENCES `pilcrow_billions_blueprints`(`className`), CONSTRAINT `pk_businessBlueprint` PRIMARY KEY(`ownerSid64`,`className`), FOREIGN KEY(`ownerSid64`) REFERENCES `pilcrow_billions_business`(`ownerSid64`))")
    MySQLite.queueQuery("CREATE TABLE IF NOT EXISTS `pilcrow_billions_businessBankLog` (`senderSid64`	bigint ( 20 ), `receiverSid64`	bigint ( 20 ), `transactionType`	int ( 11 ) NOT NULL, `amount`	int ( 11 ) NOT NULL, `title`	varchar ( 50 ), `dateTime`	datetime NOT NULL)")
    MySQLite.queueQuery("CREATE TABLE IF NOT EXISTS `pilcrow_billions_employmentHistory` (`employeeID` bigint(20) NOT NULL, `ownerSid64` bigint(20) NOT NULL, `businessName` varchar(25) NOT NULL, `dateTime` datetime NOT NULL, `position` varchar(45) NOT NULL)")
    MySQLite.queueQuery("CREATE TABLE IF NOT EXISTS `pilcrow_billions_tasks` (`type` int(12) NOT NULL, `timeType` int(12) NOT NULL, `time` int(32) NOT NULL, `className` varchar(50) NOT NULL, `amount` int(12) NOT NULL, `money` int(12), `xp` int(12))")
    MySQLite.queueQuery("CREATE TABLE IF NOT EXISTS `pilcrow_billions_businessTasks` (`ownerSid64` bigint(20) NOT NULL, `taskID` int(12) NOT NULL, `progress` int(12) NOT NULL DEFAULT 0)")
    MySQLite.commit()

    MySQLite.begin()
    for k,v in pairs(PW_Billions.CRAFTABLE.WORKBENCH) do
      if v.needBlueprint then
        MySQLite.queueQuery("INSERT OR IGNORE INTO `pilcrow_billions_blueprints` (`className`) VALUES ('" .. v.class .. "')")
      end
    end
    MySQLite.commit()
  end

  print("Billions: Database setup complete")
  hook.Run("PW_Billions_DBInitialized")
end)
