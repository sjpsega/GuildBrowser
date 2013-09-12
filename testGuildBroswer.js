
var target = UIATarget.localTarget();
var app = target.frontMostApp();
var win = app.mainWindow();
var navBar = win.navigationBar();

var testGroup = "verify guild is correct";

UIALogger.logStart(testGroup);

target.delay(5);

navBar.logElementTree();
var currentGuildName = navBar.staticTexts()[0].name();

if(currentGuildName!="Dream Catchers"){
	UIALogger.logError("The wrong guild is showing:currentGuildName=="+currentGuildName);
}else{
	UIALogger.logMessage("We found the corrent guild way");
	target.captureScreenWithName("guild");
	target.logElementTree();
	UIALogger.logPass(testGroup);
}

testGroup = "CharacterDetail Screen Test";
UIALogger.logStart(testGroup);
UIALogger.logMessage("Selecting Xofy");

var collectionView = win.collectionViews()[0];

target.captureScreenWithName("app loaded screenhot");

UIALogger.logMessage("Kicking a gnome");

character = collectionView.cells().firstWithName("Xofy");
character.tap();
character.waitForInvalid();

target.captureScreenWithName("Xofy - Character Detail");

var toolbarTitle = win.toolbar().staticTexts()[0].name();
if(toolbarTitle != "Firelord Xofy"){
	UIALogger.logError("We are kicking the wrong gnome");
	UIALogger.logFail(testGroup);
}else{
	UIALogger.logMessage("Woot boot a gnome");
	UIALogger.logPass(testGroup);
}

target.frontMostApp().toolbar().buttons()["Close"].tap();



testGroup = "ChangeGuild";
UIALogger.logStart(testGroup);
UIALogger.logMessage("selecting a new guild");
navBar.rightButton().tap();
target.frontMostApp().mainWindow().popover().textFields()[0].setValue("Fishsticks");

target.tap({x:322.00,y:252.00});
target.delay(4);

currentGuildName = navBar.staticTexts()[0].name();

if(currentGuildName!="Fishsticks"){
	UIALogger.logError("The wrong guild is showing");
	UIALogger.logFail(testGroup);
}else{
	UIALogger.logMessage("We found the current guild way");
	target.captureScreenWithName("guild");
	UIALogger.logPass(testGroup);
}