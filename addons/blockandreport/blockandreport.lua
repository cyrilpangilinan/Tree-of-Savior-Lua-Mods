function BLOCK_AND_REPORT(targetName)

	local msgBoxString = string.format("Report %s and Block new messages?", targetName);
	local blockAndReportScp = string.format("BLOCK_AND_REPORT_FUNC('%s')", targetName);
	ui.MsgBox(msgBoxString, blockAndReportScp, "None");

end

function BLOCK_AND_REPORT_FUNC(targetName)

	REPORT_AUTOBOT(targetName);
	friends.RequestBlock(targetName);

end

function CHAT_RBTN_POPUP_HOOKED(frame, chatCtrl)

	local targetName = chatCtrl:GetUserValue("TARGET_NAME");

	if session.world.IsIntegrateServer() == true then
		ui.SysMsg(ScpArgMsg("CantUseThisInIntegrateServer"));
		return;
	end

	if targetName == GETMYFAMILYNAME() then
		return;
	end

	local context = ui.CreateContextMenu("CONTEXT_CHAT_RBTN", targetName, 0, 0, 170, 100);

	ui.AddContextMenuItem(context, "Whisper", string.format("ui.WhisperTo('%s')", targetName));
	ui.AddContextMenuItem(context, "Friend Request", string.format("friends.RequestRegister('%s')", targetName));
	ui.AddContextMenuItem(context, "Party Request", string.format("PARTY_INVITE('%s')", targetName));
	ui.AddContextMenuItem(context, "Block & Report", string.format("BLOCK_AND_REPORT('%s')", targetName));
	ui.AddContextMenuItem(context, "Report", string.format("REPORT_AUTOBOT_MSGBOX('%s')", targetName));
	ui.AddContextMenuItem(context, "Block", string.format("CHAT_BLOCK_MSG('%s')", targetName));

	ui.AddContextMenuItem(context, "Cancel", "None");
	ui.OpenContextMenu(context);

end

function SHOW_PC_CONTEXT_MENU_HOOKED(handle)

	local pcObj = world.GetActor(handle);
	local targetName = pcObj:GetPCApc():GetFamilyName();

	if world.IsPVPMap() == true then
		return;
	end

	if pcObj == nil then
		return;
	end

	if pcObj:IsMyPC() == 0 and info.IsPC(pcObj:GetHandleVal()) == 1 then

		local context = ui.CreateContextMenu("PC_CONTEXT_MENU", targetName, 0, 0, 170, 100);

		ui.AddContextMenuItem(context, "Trade", string.format("exchange.RequestChange(%d)", pcObj:GetHandleVal()));

		if session.world.IsIntegrateServer() == false then

			ui.AddContextMenuItem(context, "Whisper", string.format("ui.WhisperTo('%s')", targetName));
			ui.AddContextMenuItem(context, "Party Request", string.format("PARTY_INVITE('%s')", targetName));

			if AM_I_LEADER(PARTY_GUILD) == 1 then
				ui.AddContextMenuItem(context, ClMsg("GUILD_INVITE"), string.format("GUILD_INVITE('%s')", targetName));
			end

			ui.AddContextMenuItem(context, "Visit Lodge", string.format("barrackNormal.Visit(%d)", handle));

		end

		ui.AddContextMenuItem(context, "Character Info", string.format("PROPERTY_COMPARE(%d)", handle));

		if session.world.IsIntegrateServer() == false then
			ui.AddContextMenuItem(context, "Friend Request", string.format("friends.RequestRegister('%s')", targetName));
		end

		ui.AddContextMenuItem(context, "Friendly Duel Request", string.format("REQUEST_FIGHT(%d)", pcObj:GetHandleVal()));
		ui.AddContextMenuItem(context, "Block & Report", string.format("BLOCK_AND_REPORT('%s')", targetName));
		ui.AddContextMenuItem(context, "Report", string.format("REPORT_AUTOBOT_MSGBOX('%s')", targetName));
		ui.AddContextMenuItem(context, "Block", string.format("CHAT_BLOCK_MSG('%s')", targetName));

		if session.world.IsIntegrateServer() == false then
			if session.likeit.AmILikeYou(targetName) == true then
				ui.AddContextMenuItem(context, "Cancel Like", string.format("SEND_PC_INFO(%d)", handle));
			else
				ui.AddContextMenuItem(context, "Like!", string.format("SEND_PC_INFO(%d)", handle));
			end
		end

		ui.AddContextMenuItem(context, "Cancel", "None");
		ui.OpenContextMenu(context);

		return context;

	end

end

SETUP_HOOK(CHAT_RBTN_POPUP_HOOKED, "CHAT_RBTN_POPUP");
SETUP_HOOK(SHOW_PC_CONTEXT_MENU_HOOKED, "SHOW_PC_CONTEXT_MENU");

ui.SysMsg("Block and Report loaded!");
