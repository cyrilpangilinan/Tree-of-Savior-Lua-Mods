function CREATE_JOURNALEXPORT_BUTTON()
	local frame = ui.GetFrame('journal');
	local ctrl = frame:CreateOrGetControl('button', 'DBDUMPER_DUMP', 0, 0, 150, 30);
	tolua.cast(ctrl, 'ui::CCheckBox');
	ctrl:SetMargin(30, 60, 0, 70);
	ctrl:SetGravity(ui.LEFT, ui.TOP);
	ctrl:SetText("{@st42}Export Journal{/}");
	ctrl:SetClickSound('button_click_big');
	ctrl:SetOverSound('button_over');
	ctrl:SetEventScript(ui.LBUTTONUP, 'EXPORT_JOURNAL');
	ctrl:SetCheck(filterEnabled == true and 0 or 1);
end

function EXPORT_JOURNAL()
	local file, error = io.open("../addons/journalexport/journal-drops.json", "w");

	if error then
		file:close();
	    return;
	end

	local total = 1;
	local items = {};
	local wikiList = GetClassList('Wiki');
	local wikiItems = GetWikiListByCategory('Item');

	file:write("{\n");

	for i = 1 , #wikiItems do
	    local wiki = wikiItems[i];
	    local wikiType = GetWikiType(wiki);
	    local wikiClass = GetClassByTypeFromList(wikiList, wikiType);
	    local itemClass = GetClass('Item', wikiClass.ClassName);
	    local name = itemClass.Name;
	    local className = wikiClass.ClassName;

	    file:write("\t\"" .. itemClass.ClassID .. "\": {\n\n")

	    local mobList = {};
	    GET_WIKI_SORT_LIST(wiki, 'Mon_', MAX_WIKI_ITEM_MON, mobList);

	    for m = 1 , #mobList do
	        local monsterClass = GetClassByType('Monster', mobList[m].Value);

	        if(monsterClass ~= nil) then
            	local wikimonster = GetWikiByName(monsterClass.Journal);
            	local killcount = GetWikiIntProp(wikimonster, "KillCount");
            	itemnum, quantity = FIND_WIKI_COUNT_PROP(wikimonster, "DropItem_", MAX_WIKI_MON_DROPITEM, itemClass.ClassID);

            	if(quantity ~= nil) then
                	file:write("\t\t\"" .. monsterClass.ClassID .. "\": { \n")
                	file:write("\t\t\t\"kills\": " .. killcount .. ",\n")
                	file:write("\t\t\t\"quantity\": " .. quantity .. "\n")
                	file:write("\t\t},\n")
                end

                items[total] = itemClass;
                total = total + 1;
	        end
	    end

	    file:seek("end", -3)  -- remove comma and new line
		file:write("\n\t},\n")
	end

	file:seek("end", -3)  -- remove comma and new line

	file:write("\n}\n")
	file:flush();
	file:close();
end

CREATE_JOURNALEXPORT_BUTTON();

ui.SysMsg("Journal Export loaded!");
