local function ID(msg, matches)
local hash = "group_lang:"..msg.to.id
local lang = redis:get(hash)
local hashwarn = msg.to.id..':warn'
local max_warn = tonumber(redis:get('max_warn:'..msg.to.id) or 5)
		if matches[1]:lower() == 'clean' and matches[2] == 'warns' then
			if not is_owner(msg) then
				return
			end
    local hash = msg.to.id..':warn'
    redis:del(hash)
     if not lang then
     return "_All_ *warn* _of_ *users* _in this_ *group* _has been_ *cleaned*"
   else
     return "_تمام اخطار های کاربران این گروه پاک شد_"
		end
  end
		if matches[1]:lower() == 'setwarn' then
			if not is_mod(msg) then
				return
			end
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 20 then
				if not lang then
				return "_Wrong number, range is_ *[1-20]*"
    else
				return "_لطفا عددی بین [1-20] را انتخاب کنید_"
      end
    end
			local warn_max = matches[2]
   redis:set('max_warn:'..msg.to.id, warn_max)
     if not lang then
     return "*Warn maximum* _has been set to :_ *[ "..matches[2].." ]*"
   else
     return "_حداکثر اخطار تنظیم شد به :_ *[ "..matches[2].." ]*"
		end
  end
   if matches[1] == "warn" and is_mod(msg) then
   if not matches[2] and msg.reply_to_message then
local warnhash = redis:hget(hashwarn, msg.reply.id) or 1
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
     if tonumber(msg.reply.id) == tonumber(bot.id) then
  if not lang then
  return "_I can't warn_ *my self*"
   else
  return "*من نمیتوانم به خودم اخطار دهم*"
         end
     end
   if is_mod1(msg.to.id, msg.reply.id) and not is_admin1(msg.from.id)then
  
  if not lang then
  return "_You can't warn_ *mods,owners and bot admins*"
   else
  return "*شما نمیتوانید به مدیران،صاحبان گروه، و ادمین های ربات اخطار دهید*"
         end
     end
   if is_admin1(msg.reply.id) then
  if not lang then
  return "_You can't warn_ *bot admins*"
   else
  return "*شما نمیتوانید به ادمین های ربات اخطار دهید*"
         end
     end
if tonumber(warnhash) == tonumber(max_warn) then
   kick_user(msg.reply.id, msg.to.id)
redis:hdel(hashwarn, msg.reply.id, '0')
    
	if not lang then
    return "_User_ "..username.." *"..msg.reply.id.."* _has been_ *kicked* _because max warning_\nNumber of warn :_ "..warnhash.."/"..max_warn..""
    else
    return "_کاربر_ "..username.." *"..msg.reply.id.."* به دلیل دریافت اخطار بیش از حد اخراج شد\nتعداد اخطار ها : "..warnhash.."/"..max_warn..""
    end
else
redis:hset(hashwarn, msg.reply.id, tonumber(warnhash) + 1)
    if not lang then
    return "_User_ "..username.." *"..msg.reply.id.."*\n_You've_ "..warnhash.." _of_ "..max_warn.." _Warns!_"
    else
    return "_کاربر_ "..username.." *"..msg.reply.id.."* *شما یک اخطار دریافت کردید*\n*تعداد اخطار های شما : "..warnhash.."/"..max_warn.."*"
    end
  end
	  elseif matches[2] and matches[2]:match('^%d+') then
local warnhash = redis:hget(hashwarn, matches[2]) or 1
  if not getUser(matches[2]).result then
      if lang then
  return "_کاربر یافت نشد_"
   else
  return "*User Not Found*"
      end
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
     if tonumber(matches[2]) == tonumber(bot.id) then
  if not lang then
  return "_I can't warn_ *my self*"
   else
  return "*من نمیتوانم به خودم اخطار دهم*"
         end
     end
   if is_mod1(msg.to.id, tonumber(matches[2])) and not is_admin1(msg.from.id)then
  if not lang then
  return "_You can't warn_ *mods,owners and bot admins*"
   else
  return "*شما نمیتوانید به مدیران،صاحبان گروه، و ادمین های ربات اخطار دهید*"
         end
     end
   if is_admin1(tonumber(matches[2]))then
  if not lang then
  return "_You can't warn_ *bot admins*"
   else
  return "*شما نمیتوانید به ادمین های ربات اخطار دهید*"
         end
     end
if tonumber(warnhash) == tonumber(max_warn) then
   kick_user(matches[2], msg.to.id)
redis:hdel(hashwarn, matches[2], '0')
    if not lang then
    return "_User_ "..user_name.." *"..matches[2].."* _has been_ *kicked* _because max warning_\nNumber of warn :_ "..warnhash.."/"..max_warn..""
    else
    return "_کاربر_ "..user_name.." *"..matches[2].."* به دلیل دریافت اخطار بیش از حد اخراج شد\nتعداد اخطار ها : "..warnhash.."/"..max_warn..""
    end
else
redis:hset(hashwarn, matches[2], tonumber(warnhash) + 1)
	if not lang then
    return "_User_ "..user_name.." *"..matches[2].."*\n_You've_ "..warnhash.." _of_ "..max_warn.." _Warns!_"
    else
    return "_کاربر_ "..user_name.." *"..matches[2].."* *شما یک اخطار دریافت کردید*\n*تعداد اخطار های شما : "..warnhash.."/"..max_warn.."*"
    end
  end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   if lang then
  return "_کاربر یافت نشد_"
   else
  return "*User Not Found*"
      end
    end
   local status = resolve_username(matches[2]).information
local warnhash = redis:hget(hashwarn, status.id) or 1
     if tonumber(status.id) == tonumber(bot.id) then
  if not lang then
  return "_I can't warn_ *my self*"
   else
  return "*من نمیتوانم به خودم اخطار دهم*"
         end
     end
   if is_mod1(msg.to.id, tonumber(status.id)) and not is_admin1(msg.from.id)then
   if not lang then
  return "_You can't warn_ *mods,owners and bot admins*"
   else
  return "*شما نمیتوانید به مدیران،صاحبان گروه، و ادمین های ربات اخطار دهید*"
         end
     end
   if is_admin1(tonumber(status.id))then
  if not lang then
  return "_You can't warn_ *bot admins*"
   else
  return "*شما نمیتوانید به ادمین های ربات اخطار دهید*"
         end
     end
if tonumber(warnhash) == tonumber(max_warn) then
   kick_user(status.id, msg.to.id)
redis:hdel(hashwarn, status.id, '0')
    
	if not lang then
    return "_User_ @"..check_markdown(status.username).." *"..status.id.."* _has been_ *kicked* _because max warning_\nNumber of warn :_ "..warnhash.."/"..max_warn..""
    else
    return "_کاربر_ @"..check_markdown(status.username).." *"..status.id.."* به دلیل دریافت اخطار بیش از حد اخراج شد\nتعداد اخطار ها : "..warnhash.."/"..max_warn..""
    end
else
redis:hset(hashwarn, status.id, tonumber(warnhash) + 1)
	if not lang then
    return "_User_ @"..check_markdown(status.username).." *"..status.id.."*\n_You've_ "..warnhash.." _of_ "..max_warn.." _Warns!_"
    else
    return "_کاربر_ @"..check_markdown(status.username).." *"..status.id.."* *شما یک اخطار دریافت کردید*\n*تعداد اخطار های شما : "..warnhash.."/"..max_warn.."*"
    end
    end
  end
end
   if matches[1] == "unwarn" and is_mod(msg) then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
-- local warnhash = redis:hget(hashwarn, msg.reply.id) or 1	-- if needed
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
if not redis:hget(hashwarn, msg.reply.id) then
	if not lang then
    return "_User_ "..username.." *"..msg.reply.id.."* _don't have_ *warning*"
   else
    return "_کاربر_ "..username.." *"..msg.reply.id.."* *هیچ اخطاری دریافت نکرده*"
    end
  else
redis:hdel(hashwarn, msg.reply.id, '0')
	if not lang then
    return "_All warn of_ "..username.." *"..msg.reply.id.."* _has been_ *cleaned*"
   else
    return "_تمامی اخطار های_ "..username.." *"..msg.reply.id.."* *پاک شدند*"
    end
   end
	  elseif matches[2] and matches[2]:match('^%d+') then
-- local warnhash = redis:hget(hashwarn, matches[2]) or 1	-- if needed
  if not getUser(matches[2]).result then
   if lang then
  return "_کاربر یافت نشد_"
   else
  return "*User Not Found*"
      end
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
if not redis:hget(hashwarn, matches[2]) then
    if not lang then
    return "_User_ "..user_name.." *"..matches[2].."* _don't have_ *warning*"
   else
    return "_کاربر_ "..user_name.." *"..matches[2].."* *هیچ اخطاری دریافت نکرده*"
    end
  else
redis:hdel(hashwarn, matches[2], '0')
    if not lang then
    return "_All warn of_ "..user_name.." *"..matches[2].."* _has been_ *cleaned*"
   else
    return "_تمامی اخطار های_ "..user_name.." *"..matches[2].."* *پاک شدند*"
    end
   end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   if lang then
  return "_کاربر یافت نشد_"
   else
  return "*User Not Found*"
      end
    end
   local status = resolve_username(matches[2]).information
-- local warnhash = redis:hget(hashwarn, status.id) or 1	-- if needed
if not redis:hget(hashwarn, status.id) then
    if not lang then
    return "_User_ @"..check_markdown(status.username).." *"..status.id.."* _don't have_ *warning*"
   else
    return "_کاربر_ @"..check_markdown(status.username).." *"..status.id.."* *هیچ اخطاری دریافت نکرده*"
    end
  else
redis:hdel(hashwarn, status.id, '0')
    if not lang then
    return "_All warn of_ @"..check_markdown(status.username).." *"..status.id.."* _has been_ *cleaned*"
   else
    return "_تمامی اخطار های_ @"..check_markdown(status.username).." *"..status.id.."* *پاک شدند*"
    end
    end
  end
end
	if matches[1] == "warnlist" and is_mod(msg) then
		if lang then
		list = 'لیست کاربران اخطار گرفنه:\n'
		else
		list = 'Warn Users List:\n'
		end
		local empty = list
		for k,v in pairs (redis:hkeys(msg.to.id..':warn')) do
			local user_info = redis:hgetall('user:'..v)
			local cont = redis:hget(msg.to.id..':warn', v)
		if user_info and user_info.user_name then
		list = list..k..'- '..user_info.user_name..' ['..v..'] Warn : '..(cont - 1)..'\n'
       else
		list = list..k..'- '..v..' Warn : '..(cont - 1)..'\n'
      end
    end
		if list == empty then
		if lang then
		return 'لیست اخطار خالی است.'
		else
		return 'WarnList is Empty'
		end
		else
		 send_msg(msg.to.id, list)
		end
	end
end
local function pre_process(msg)
    local hash = 'user:'..msg.from.id
    if msg.from.username then
     user_name = '@'..msg.from.username
  else
     user_name = msg.from.print_name
    end
      redis:hset(hash, 'user_name', user_name)
end

return {
  patterns = {
  "^[#!/](warn)$",
  "^[#!/](warn) (.*)$",
  "^[#!/](unwarn)$",
  "^[#!/](unwarn) (.*)$",
  "^[!/#](setwarn) (%d+)$",
  "^[#!/](clean) (warns)$",
  "^[#!/](warnlist)$",

  },
  run = ID,
	pre_process = pre_process
}

