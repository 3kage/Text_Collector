local _G = _G;    
local TC_date = "2023-02-09";
local TC_version = GetAddOnMetadata("TextCollector", "Version");
local TC_name  = UnitName("player");
local TC_class = UnitClass("player");
local TC_race  = UnitRace("player");
local TC_patch = GetBuildInfo();
local TC_realm = GetLocale();
local TC_time = GetTime();
local TC_movieID = 0;

local TC_Messages = {      
	loaded            = "запустився",
   active            = "активувати аддон",
	is_now_active     = "зараз активний",
	is_now_not_active = "ID зараз неактивний",
	check_quest       = "збирати тексти квестів",
	check_gossip      = "збирати тексти плиток",
	check_bubble      = "збирати бульбашкові тексти",
	check_item        = "збирати тексти предметів",
	check_spell       = "збирати тексти заклинань",
	check_talent      = "збирати тексти талантів",
	check_movie       = "збирати тексти фільмів і кіно",
	check_book        = "збирати тексти книжок",
	info_upload1      = "Цей аддон збирає тексти з вашої області в локальний файл:",
	info_upload2      = "WOW/_retail_/WTF/Account/[number_of_server]/SavedVariables/TextCollector.lua",
	info_upload3      = "Будь ласка, надішліть його мені в діскорді (користувач):",
   info_upload4      = "icednicco#8435",
   info_upload5      = "клацніть і натисніть Ctrl+C, щоб скопіювати в буфер обміну Windows",
   info_upload6      = "Слава Україні!",
};	


local function StringHash(text)          
   local counter = 1;
   local pomoc = 0;
   local dlug = string.len(text);
   for i = 1, dlug, 3 do 
      counter = math.fmod(counter*8161, 4294967279); 
      pomoc = (string.byte(text,i)*16776193);
      counter = counter + pomoc;
      pomoc = ((string.byte(text,i+1) or (dlug-i+256))*8372226);
      counter = counter + pomoc;
      pomoc = ((string.byte(text,i+2) or (dlug-i+256))*3932164);
      counter = counter + pomoc;
   end
   return math.fmod(counter, 4294967291);  
end


local function ClearText(text)
   local Czysty_Text = string.gsub(text, '\r', '');
   Czysty_Text = string.gsub(Czysty_Text, '\n', '$B');
   Czysty_Text = string.gsub(Czysty_Text, TC_name, '$N');
   Czysty_Text = string.gsub(Czysty_Text, string.upper(TC_name), '$N$');
   Czysty_Text = string.gsub(Czysty_Text, TC_race, '$R');
   Czysty_Text = string.gsub(Czysty_Text, string.lower(TC_race), '$R');
   Czysty_Text = string.gsub(Czysty_Text, TC_class, '$C');
   Czysty_Text = string.gsub(Czysty_Text, string.lower(TC_class), '$C');
   Czysty_Text = string.gsub(Czysty_Text, '$N$', '');
   Czysty_Text = string.gsub(Czysty_Text, '$N', '');
   Czysty_Text = string.gsub(Czysty_Text, '$B', '');
   Czysty_Text = string.gsub(Czysty_Text, '$R', '');
   Czysty_Text = string.gsub(Czysty_Text, '$C', '');
   return (Czysty_Text);
end


local function WyczyscText(txt)
   text = string.gsub(txt,"|cFFFFFFFF","");
   text = string.gsub(text,"|r","");
   text = string.gsub(text,"\r","");
   text = string.gsub(text,"\n","");
   text = string.gsub(text,"(%d),(%d)","%1%2");   
   text = string.gsub(text,"0","");
   text = string.gsub(text,"1","");
   text = string.gsub(text,"2","");
   text = string.gsub(text,"3","");
   text = string.gsub(text,"4","");
   text = string.gsub(text,"5","");
   text = string.gsub(text,"6","");
   text = string.gsub(text,"7","");
   text = string.gsub(text,"8","");
   text = string.gsub(text,"9","");
   return (text);
end


local function OkreslKodKoloru(k1,k2,k3)
   kol1=('%.0f'):format(k1);
   kol2=('%.0f'):format(k2);
   kol3=('%.0f'):format(k3);
   c_out=kol1..","..kol2..","..kol3;
   if (kol1=="1" and kol2=="1" and kol3=="1") then
      c_out='c1';
   elseif (kol1=="1" and kol2=="0" and kol3=="0") then
      c_out='c2';
   elseif (kol1=="1" and kol2=="1" and kol3=="0") then
      c_out='c3';
   elseif (kol1=="0" and kol2=="1" and kol3=="0") then
      c_out='c4';
   elseif (kol1=="1" and kol2=="0" and kol3=="1") then
      c_out='c5';
   end
   return c_out;   
end


function TC_CheckVars()
  if (not TC_C) then
     TC_C = {};
  end
  if (not TC_Q) then
     TC_Q = {};
  end
  if (not TC_G) then
     TC_G = {};
  end
  if (not TC_B) then
     TC_B = {};
  end
  if (not TC_I) then
     TC_I = {};
  end
  if (not TC_S) then
     TC_S = {};
  end
  if (not TC_T) then
     TC_T = {};
  end
  if (not TC_H) then
     TC_H = {};
  end
  if (not TC_M) then
     TC_M = {};
  end
  if (not TC_K) then
     TC_K = {};
  end
 
  TC_C["realm"] = TC_realm;
  TC_C["patch"] = TC_patch;
  if (not TC_C["active"] ) then    
     TC_C["active"] = "1";
  end
  if (not TC_C["quest"] ) then      
     TC_C["quest"] = "1";   
  end
  if (not TC_C["gossip"] ) then     
     TC_C["gossip"] = "1";   
  end
  if (not TC_C["bubble"] ) then   
     TC_C["bubble"] = "1";   
  end
  if (not TC_C["item"] ) then       
     TC_C["item"] = "1";   
  end
  if (not TC_C["spell"] ) then      
     TC_C["spell"] = "1";   
  end
  if (not TC_C["talent"] ) then     
     TC_C["talent"] = "1";   
  end
  if (not TC_C["movie"] ) then      
     TC_C["movie"] = "1";   
  end
  if (not TC_C["book"] ) then     
     TC_C["book"] = "1";   
  end
end
  

function TC_SlashCommand(msg)
  
  if (msg) then
     local TC_command = string.lower(msg);               
     if ((TC_command=="on") or (TC_command=="1")) then    
        TC_C["active"]="1";
        print("|cffffff00TextCollector "..TC_Messages.is_now_active);
     elseif ((TC_command=="off") or (TC_command=="0")) then
        TC_C["active"]="0";
        print("|cffffff00TextCollector "..TC_Messages.is_now_not_active);
     else
        Settings.OpenToCategory("TextCollector");
     end   
  end
end


function TC_SetCheckButtonState()
  TCCheckButton0:SetValue(TC_C["active"]=="1");
  TCCheckButton1:SetValue(TC_C["quest"]=="1");
  TCCheckButton2:SetValue(TC_C["gossip"]=="1");
  TCCheckButton3:SetValue(TC_C["bubble"]=="1");
  TCCheckButton4:SetValue(TC_C["item"]=="1");
  TCCheckButton5:SetValue(TC_C["spell"]=="1");
  TCCheckButton6:SetValue(TC_C["talent"]=="1");
  TCCheckButton7:SetValue(TC_C["movie"]=="1");
  TCCheckButton8:SetValue(TC_C["book"]=="1");
end


function TC_BlizzardOptions()


local TCOptions = CreateFrame("FRAME", "TextCollectorOptions");
TCOptions.refresh = function (self) TC_SetCheckButtonState() end;
TCOptions.name = "TextCollector";
InterfaceOptions_AddCategory(TCOptions);

local TCOptionsHeader = TCOptions:CreateFontString(nil, "ARTWORK");
TCOptionsHeader:SetFontObject(GameFontNormalLarge);
TCOptionsHeader:SetJustifyH("LEFT"); 
TCOptionsHeader:SetJustifyV("TOP");
TCOptionsHeader:ClearAllPoints();
TCOptionsHeader:SetPoint("TOPLEFT", 16, -16);
TCOptionsHeader:SetText("TextCollector, ver. "..TC_version.." ("..TC_date..") by icednicco");

local TCCheckButton0 = CreateFrame("CheckButton", "TCCheckButton0", TCOptions, "SettingsCheckBoxControlTemplate");
TCCheckButton0.CheckBox:SetScript("OnClick", function(self) if (TC_C["active"]=="1") then TC_C["active"]="0" else TC_C["active"]="1" end; end);
TCCheckButton0.CheckBox:SetPoint("TOPLEFT", TCOptionsHeader, "BOTTOMLEFT", 0, -30);
TCCheckButton0:SetPoint("TOPLEFT", TCOptionsHeader, "BOTTOMLEFT", 40, -30);
TCCheckButton0.Text:SetText(TC_Messages.active);    

local TCCheckButton1 = CreateFrame("CheckButton", "TCCheckButton1", TCOptions, "SettingsCheckBoxControlTemplate");
TCCheckButton1.CheckBox:SetScript("OnClick", function(self) if (TC_C["quest"]=="1") then TC_C["quest"]="0" else TC_C["quest"]="1" end; end);
TCCheckButton1.CheckBox:SetPoint("TOPLEFT", TCCheckButton0.CheckBox, "BOTTOMLEFT", 30, -30);
TCCheckButton1:SetPoint("TOPLEFT", TCCheckButton0.CheckBox, "BOTTOMLEFT", 70, -30);
TCCheckButton1.Text:SetText(TC_Messages.check_quest);

local TCCheckButton2 = CreateFrame("CheckButton", "TCCheckButton2", TCOptions, "SettingsCheckBoxControlTemplate");
TCCheckButton2.CheckBox:SetScript("OnClick", function(self) if (TC_C["gossip"]=="1") then TC_C["gossip"]="0" else TC_C["gossip"]="1" end; end);
TCCheckButton2.CheckBox:SetPoint("TOPLEFT", TCCheckButton1.CheckBox, "BOTTOMLEFT", 0, 0);
TCCheckButton2:SetPoint("TOPLEFT", TCCheckButton1.CheckBox, "BOTTOMLEFT", 40, 0);
TCCheckButton2.Text:SetText(TC_Messages.check_gossip);

local TCCheckButton3 = CreateFrame("CheckButton", "TCCheckButton3", TCOptions, "SettingsCheckBoxControlTemplate");
TCCheckButton3.CheckBox:SetScript("OnClick", function(self) if (TC_C["bubble"]=="1") then TC_C["bubble"]="0" else TC_C["bubble"]="1" end; end);
TCCheckButton3.CheckBox:SetPoint("TOPLEFT", TCCheckButton2.CheckBox, "BOTTOMLEFT", 0, 0);
TCCheckButton3:SetPoint("TOPLEFT", TCCheckButton2.CheckBox, "BOTTOMLEFT", 40, 0);
TCCheckButton3.Text:SetText(TC_Messages.check_bubble);

local TCCheckButton4 = CreateFrame("CheckButton", "TCCheckButton4", TCOptions, "SettingsCheckBoxControlTemplate");
TCCheckButton4.CheckBox:SetScript("OnClick", function(self) if (TC_C["item"]=="1") then TC_C["item"]="0" else TC_C["item"]="1" end; end);
TCCheckButton4.CheckBox:SetPoint("TOPLEFT", TCCheckButton3.CheckBox, "BOTTOMLEFT", 0, 0);
TCCheckButton4:SetPoint("TOPLEFT", TCCheckButton3.CheckBox, "BOTTOMLEFT", 40, 0);
TCCheckButton4.Text:SetText(TC_Messages.check_item);

local TCCheckButton5 = CreateFrame("CheckButton", "TCCheckButton5", TCOptions, "SettingsCheckBoxControlTemplate");
TCCheckButton5.CheckBox:SetScript("OnClick", function(self) if (TC_C["spell"]=="1") then TC_C["spell"]="0" else TC_C["spell"]="1" end; end);
TCCheckButton5.CheckBox:SetPoint("TOPLEFT", TCCheckButton4.CheckBox, "BOTTOMLEFT", 0, 0);
TCCheckButton5:SetPoint("TOPLEFT", TCCheckButton4.CheckBox, "BOTTOMLEFT", 40, 0);
TCCheckButton5.Text:SetText(TC_Messages.check_spell);

local TCCheckButton6 = CreateFrame("CheckButton", "TCCheckButton6", TCOptions, "SettingsCheckBoxControlTemplate");
TCCheckButton6.CheckBox:SetScript("OnClick", function(self) if (TC_C["talent"]=="1") then TC_C["talent"]="0" else TC_C["talent"]="1" end; end);
TCCheckButton6.CheckBox:SetPoint("TOPLEFT", TCCheckButton5.CheckBox, "BOTTOMLEFT", 0, 0);
TCCheckButton6:SetPoint("TOPLEFT", TCCheckButton5.CheckBox, "BOTTOMLEFT", 40, 0);
TCCheckButton6.Text:SetText(TC_Messages.check_talent);

local TCCheckButton7 = CreateFrame("CheckButton", "TCCheckButton7", TCOptions, "SettingsCheckBoxControlTemplate");
TCCheckButton7.CheckBox:SetScript("OnClick", function(self) if (TC_C["talent"]=="1") then TC_C["talent"]="0" else TC_C["talent"]="1" end; end);
TCCheckButton7.CheckBox:SetPoint("TOPLEFT", TCCheckButton6.CheckBox, "BOTTOMLEFT", 0, 0);
TCCheckButton7:SetPoint("TOPLEFT", TCCheckButton6.CheckBox, "BOTTOMLEFT", 40, 0);
TCCheckButton7.Text:SetText(TC_Messages.check_movie);

local TCCheckButton8 = CreateFrame("CheckButton", "TCCheckButton8", TCOptions, "SettingsCheckBoxControlTemplate");
TCCheckButton8.CheckBox:SetScript("OnClick", function(self) if (TC_C["talent"]=="1") then TC_C["talent"]="0" else TC_C["talent"]="1" end; end);
TCCheckButton8.CheckBox:SetPoint("TOPLEFT", TCCheckButton7.CheckBox, "BOTTOMLEFT", 0, 0);
TCCheckButton8:SetPoint("TOPLEFT", TCCheckButton7.CheckBox, "BOTTOMLEFT", 40, 0);
TCCheckButton8.Text:SetText(TC_Messages.check_book);


local TCText1 = TCOptions:CreateFontString(nil, "ARTWORK");
TCText1:SetFontObject(GameFontWhite);
TCText1:SetJustifyH("LEFT");
TCText1:SetJustifyV("TOP");
TCText1:ClearAllPoints();
TCText1:SetPoint("TOPLEFT", TCCheckButton8.CheckBox, "BOTTOMLEFT", 0, -50);
TCText1:SetText(TC_Messages.info_upload1);

local TCText2 = TCOptions:CreateFontString(nil, "ARTWORK");
TCText2:SetFontObject(GameFontWhite);
TCText2:SetJustifyH("LEFT");
TCText2:SetJustifyV("TOP");
TCText2:ClearAllPoints();
TCText2:SetPoint("TOPLEFT", TCText1, "BOTTOMLEFT", 0, -10);
TCText2:SetText(TC_Messages.info_upload2);

local TCText3 = TCOptions:CreateFontString(nil, "ARTWORK");
TCText3:SetFontObject(GameFontWhite);
TCText3:SetJustifyH("LEFT");
TCText3:SetJustifyV("TOP");
TCText3:ClearAllPoints();
TCText3:SetPoint("TOPLEFT", TCText2, "BOTTOMLEFT", 0, -10);
TCText3:SetText(TC_Messages.info_upload3);

local TCWWW = CreateFrame("EditBox", "TCWWW", TCOptions, "InputBoxTemplate");
TCWWW:ClearAllPoints();
TCWWW:SetPoint("TOPLEFT", TCText3, "BOTTOMLEFT", 0, -10);
TCWWW:SetHeight(20);
TCWWW:SetWidth(350);
TCWWW:SetAutoFocus(false);
TCWWW:SetFontObject(GameFontGreen);
TCWWW:SetText(TC_Messages.info_upload4);
TCWWW:SetCursorPosition(0);
TCWWW:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
   GameTooltip:SetText(TC_Messages.info_upload5, nil, nil, nil, nil, true)
   GameTooltip:Show()
   end);
TCWWW:SetScript("OnLeave", function(self)
   GameTooltip:Hide() 
   end);
TCWWW:SetScript("OnTextChanged", function(self) TCWWW:SetText(TC_Messages.info_upload4); end);

end


local function TC_GossipOnQuestFrame()
   if ((GreetingText:IsVisible()) and (TC_C["active"]=="1") and (TC_C["gossip"]=="1")) then   
      local name_NPC = QuestFrameTitleText:GetText();
      if (name_NPC == nil) then
         nameNPC = "?";
      end
      local gossip_txt = GreetingText:GetText();
      local gossip_clr = ClearText(gossip_txt);
      local gossip_hash = StringHash(gossip_clr);
      TC_G[gossip_hash] = name_NPC.."@"..gossip_txt.."@"..TC_name.."@"..TC_race.."@"..TC_class.."@"..TC_patch;
   end
end


local function TC_ChatFilter(self, event, arg1, arg2, arg3, _, arg5, ...)   
   if ((TC_C["active"]=="1") and (TC_C["bubble"]=="1")) then
      local bubble_txt = strtrim(arg1);
      local name_NPC = string.gsub(arg2, " says:", "");
      local target = arg5;
      local bubble_clr = ClearText(bubble_txt);
      local bubble_hash = StringHash(bubble_clr);
      TC_B[bubble_hash] = name_NPC.."@"..bubble_txt.."@"..target.."@"..TC_name.."@"..TC_race.."@"..TC_class.."@"..TC_patch;
   end
end


local function TC_ShowMovieSubtitles()      
   local TC_readed_MV = MovieFrameSubtitleString:GetText();
   local TC_readed_HS = StringHash(TC_readed_MV);
   local MF_ID = tostring(TC_movieID);
   while (string.len(MF_ID)<3) do
      MF_ID = "0"..MF_ID;
   end
   TC_M[TC_readed_HS] = TC_readed_MV.."@movie@"..MF_ID.."@"..tostring(GetTime()).."@"..TC_patch;
end


local function TC_ShowCinematicSubtitles()      
   if (GetTime() - TC_time > 0.25) then         
      if (CinematicFrame.Subtitle1 and CinematicFrame.Subtitle1:IsVisible()) then      
         local TC_readed_CM = CinematicFrame.Subtitle1:GetText();     
         local TC_readed_HS = StringHash(TC_readed_CM);
         TC_M[TC_readed_HS] = TC_readed_CM.."@cinematic@"..tostring(GetTime()).."@"..TC_name.."@"..TC_race.."@"..TC_class.."@"..TC_patch;
         TC_time = GetTime() + 1;                                     
      end
   end
end


local function TC_BookReader()
   if ((TC_C["active"]=="1") and (TC_C["book"]=="1")) then
      local TC_bookTitle=ItemTextGetItem();
      local TC_bookText=ItemTextGetText();
      local TC_bookPageNo=tostring(ItemTextGetPage());
      TC_K[TC_bookTitle.."@"..TC_bookPageNo]=TC_bookText.."@"..TC_patch;
   end
end



function TC_OnEvent(self, event, name, ...)
   if (event=="ADDON_LOADED" and name=="TextCollector") then
      SlashCmdList["TEXTCOLLECTOR"] = function(msg) TC_SlashCommand(msg); end
      SLASH_TEXTCOLLECTOR1 = "/textcollector";
      SLASH_TEXTCOLLECTOR2 = "/tc";
      TC_CheckVars();
      TC_BlizzardOptions();
      print("|cffffff00TextCollector ver. "..TC_version.." - "..TC_Messages.loaded);
      TC:UnregisterEvent("ADDON_LOADED");
      TC.ADDON_LOADED = nil;
      QuestFrame:SetScript("OnShow", TC_GossipOnQuestFrame);
      ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_SAY", TC_ChatFilter);
      ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_YELL", TC_ChatFilter);
      ItemTextFrame:HookScript("OnShow", function() TC_BookReader() end);
      ItemTextNextPageButton:HookScript("OnClick", function() TC_BookReader() end);
      ItemTextPrevPageButton:HookScript("OnClick", function() TC_BookReader() end);
      
   elseif ((event=="QUEST_DETAIL") and (TC_C["active"]=="1") and (TC_C["quest"]=="1")) then
      local quest_ID = GetQuestID();
      local quest_obj= GetObjectiveText();
      local quest_det= GetQuestText();
      TC_Q[quest_ID.." TITLE"] = GetTitleText().."@"..TC_name.."@"..TC_race.."@"..TC_class.."@"..TC_patch;
      TC_Q[quest_ID.." OBJECTIVES"] = quest_obj.."@"..TC_name.."@"..TC_race.."@"..TC_class.."@"..TC_patch;
      TC_Q[quest_ID.." DETAILS"] = quest_det.."@"..TC_name.."@"..TC_race.."@"..TC_class.."@"..TC_patch;
      
   elseif ((event=="QUEST_PROGRESS") and (TC_C["active"]=="1") and (TC_C["quest"]=="1")) then
      local quest_ID = GetQuestID();
      local quest_pro= GetProgressText();
      TC_Q[quest_ID.." PROGRESS"] = quest_pro.."@"..TC_name.."@"..TC_race.."@"..TC_class.."@"..TC_patch;
           
   elseif ((event=="QUEST_COMPLETE") and (TC_C["active"]=="1") and (TC_C["quest"]=="1")) then
      local quest_ID = GetQuestID();
      local quest_com= GetRewardText();
      TC_Q[quest_ID.." COMPLETION"] = quest_com.."@"..TC_name.."@"..TC_race.."@"..TC_class.."@"..TC_patch;
      
   elseif ((event=="GOSSIP_SHOW") and (TC_C["active"]=="1") and (TC_C["gossip"]=="1")) then
      local name_NPC = GossipFrameTitleText:GetText();
      if (name_NPC == nil) then
         nameNPC = "?";
      end
      local gossip_txt = C_GossipInfo:GetText();
      local gossip_clr = ClearText(gossip_txt);
      local gossip_hash = StringHash(gossip_clr);
      TC_G[gossip_hash] = name_NPC.."@"..gossip_txt.."@"..TC_name.."@"..TC_race.."@"..TC_class.."@"..TC_patch;      

   elseif ((event=="PLAY_MOVIE") and (TC_C["active"]=="1") and (TC_C["movie"]=="1")) then   
      TC_movieID = name;
      TC_time = GetTime();
      MovieFrame:HookScript("OnMovieShowSubtitle", TC_ShowMovieSubtitles);
      
   elseif ((event=="CINEMATIC_START") and (TC_C["active"]=="1") and (TC_C["movie"]=="1")) then
      TC_time = GetTime();
      CinematicFrame:HookScript("OnUpdate", TC_ShowCinematicSubtitles);
      
   elseif ((event=="CINEMATIC_STOP") and (TC_C["active"]=="1") and (TC_C["movie"]=="1")) then
      CinematicFrame:SetScript("OnUpdate", nil);
      
   end
end



function TC_GameTooltip_ShowItem(obj)
   local TC_itemName, TC_itemLink = obj:GetItem();
   if (TC_itemName) then                             
      local TC_itemID, TC_itemType, TC_itemSubType = GetItemInfoInstant(TC_itemLink);
      if (not TC_itemID) then
         return;
      end   
      TC_I[TC_itemID] = TC_itemName.."@"..TC_itemType.."@"..TC_itemSubType.."@"..TC_patch;      
      local TC_numLines = obj:NumLines();      
      local TC_leftText, TC_loftColR, TC_leftColF, TC_leftColB, TC_kodKoloru, TC_hash;
      for i = 2, TC_numLines, 1 do
         TC_leftText = _G[obj:GetName().."TextLeft"..i]:GetText();
         TC_leftColR, TC_leftColG, TC_leftColB = _G[obj:GetName().."TextLeft"..i]:GetTextColor();
         TC_kodKoloru = OkreslKodKoloru(TC_leftColR, TC_leftColG, TC_leftColB);
         if ((TC_kodKoloru=="c3") and (TC_itemID ~= 6948)) then   
            TC_hash = StringHash(WyczyscText(TC_leftText));
            TC_H[TC_hash] = "i"..TC_itemID.."@"..TC_leftText.."@"..TC_patch;      
         end
      end
   end
end     
   
   

function TC_GameTooltip_ShowSpell(obj)
   local TC_spellName, TC_spellID = obj:GetSpell();
   if (TC_spellName) then                            
      local TC_prefix = "s";
      if (ClassTalentFrame and ClassTalentFrame:IsVisible() and string.sub(ClassTalentFrameTitleText:GetText(),1,6)=="Talent") then
         local PTFleft = ClassTalentFrame:GetLeft();
         local PTFright = ClassTalentFrame:GetRight();
         local PTFbootom = ClassTalentFrame:GetBottom();
         local PTFtop = ClassTalentFrame:GetTop();
         local x,y = GetCursorPosition();
         if (x>PTFleft and x<PTFright and y>PTFbootom and y<PTFtop) then     
            TC_prefix = "t";
         end
      end
      if ((TC_prefix == "s") and (TC_C["spell"]=="1")) then
         TC_S[TC_spellID] = TC_spellName.."@"..TC_race.."@"..TC_class.."@"..TC_patch;
      elseif ((TC_prefix == "t") and (TC_C["talent"]=="1")) then
         TC_T[TC_spellID] = TC_spellName.."@"..TC_race.."@"..TC_class.."@"..TC_patch;
      else
         return;
      end
      local TC_numLines = obj:NumLines();  
      local TC_leftText, TC_loftColR, TC_leftColF, TC_leftColB, TC_kodKoloru, TC_hash, TC_pomoc2, TC_pomoc3;
      for i = 2, TC_numLines, 1 do
         TC_leftText = _G[obj:GetName().."TextLeft"..i]:GetText();
         TC_leftColR, TC_leftColG, TC_leftColB = _G[obj:GetName().."TextLeft"..i]:GetTextColor();
         TC_kodKoloru = OkreslKodKoloru(TC_leftColR, TC_leftColG, TC_leftColB);
         TC_pomoc2, _ = string.find(TC_leftText,"+");           
         TC_pomoc3, _ = string.find(TC_leftText,"Item Level");
         if (((TC_kodKoloru=="c3") or (TC_kodKoloru=="c3")) and (TC_pomoc2==nil) and (TC_pomoc3==nil)) then    
            TC_hash = StringHash(WyczyscText(TC_leftText));
            TC_H[TC_hash] = TC_prefix..TC_spellID.."@"..TC_leftText.."@"..TC_patch;      
         end
      end
   end
end

   
GameTooltip:HookScript('OnShow', function(self, ...)    
   if (TC_C["active"]=="1") then       
      if ((self:GetOwner():GetName()==nil) or (self:GetOwner():GetName()=="UIParent")) then
         return;
      end
      local TC_itemNameX, TC_itemLink = self:GetItem();
      local TC_spellNameX, TC_spellID = self:GetSpell();
      if ((TC_itemNameX) and (TC_C["item"]=="1")) then
         TC_GameTooltip_ShowItem(self);
      end
      if ((TC_spellNameX) and ((TC_C["spell"]=="1") or (TC_C["talent"]=="1"))) then
         TC_GameTooltip_ShowSpell(self);
      end
   end
end      
);
   

MovieFrame:HookScript("OnShow", function(self, ...)
   if ((TC_C["active"]=="1") and (TC_C["movie"]=="1")) then   
      TC_movieID = 0;
      TC_time = GetTime();
      MovieFrame:HookScript("OnMovieShowSubtitle", TC_ShowMovieSubtitles);
   end
end     
);


TC = CreateFrame("Frame");
TC:SetScript("OnEvent", TC_OnEvent);
TC:RegisterEvent("ADDON_LOADED");
TC:RegisterEvent("QUEST_DETAIL");
TC:RegisterEvent("QUEST_PROGRESS");
TC:RegisterEvent("QUEST_COMPLETE");
TC:RegisterEvent("GOSSIP_SHOW");
TC:RegisterEvent("PLAY_MOVIE");
TC:RegisterEvent("CINEMATIC_START");
TC:RegisterEvent("CINEMATIC_STOP");
