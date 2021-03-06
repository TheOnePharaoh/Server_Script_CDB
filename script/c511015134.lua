--Rank-Up-Magic Admiration of the Thousands (Anime)
function c511015134.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511015134.target)
	e1:SetOperation(c511015134.activate)
	c:RegisterEffect(e1)
end
function c511015134.filter(c,e)
	return c:IsSetCard(0x1048) and c:IsType(TYPE_XYZ) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c511015134.xyzfilter(c,sg,e,tp)
	if not c:IsSetCard(0x1048) or Duel.GetLocationCountFromEx(tp,tp,sg,c)<=0 then return false end
	if c.rum_limit and not sg:IsExists(function(mc) return c.rum_limit(mc,e) end,1,nil) then return false end
	local se=nil
	if c.rum_xyzsummon then
		se=c.rum_xyzsummon(c)
	end
	local res=c:IsXyzSummonable(sg,sg:GetCount(),sg:GetCount())
	if se then
		se:Reset()
	end
	return res
end
function c511015134.chkfilter(c,g,sg,e,tp)
	sg:AddCard(c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetValue(tc:GetRank()+1)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2=nil
	if c:IsControler(1-tp) then
		e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_XYZ_MATERIAL)
		e2:SetReset(RESET_CHAIN)
		c:RegisterEffect(e2)
	end
	local res=Duel.IsExistingMatchingCard(c511015134.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,sg,e,tp) 
		or g:IsExists(c511015134.chkfilter,1,sg,g,sg,e,tp)
	e1:Reset()
	if e2 then e2:Reset() end
	sg:RemoveCard(c)
	return res
end
function c511015134.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local sg=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(c511015134.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	if chk==0 then return mg:IsExists(c511015134.chkfilter,1,nil,mg,sg,e,tp) end
	local reset={}
	local tc
	::start::
		local cancel=sg:GetCount()>0 and Duel.IsExistingMatchingCard(c511015134.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,sg,e,tp)
		local tg=mg:Filter(c511015134.chkfilter,sg,mg,sg,e,tp)
		if tg:GetCount()<=0 then goto jump end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		tc=Group.SelectUnselect(tg,sg,tp,cancel,cancel)
		if not tc then goto jump end
		if sg:IsContains(tc) then
			sg:RemoveCard(tc)
			reset[tc][0]:Reset()
			if reset[tc][1] then
				reset[tc][1]:Reset()
			end
			reset[tc]=nil
		else
			sg:AddCard(tc)
			reset[tc]={}
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_XYZ_LEVEL)
			e1:SetValue(tc:GetRank()+1)
			e1:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e1)
			reset[tc][0]=e1
			local e2=nil
			if tc:IsControler(1-tp) then
				e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_XYZ_MATERIAL)
				e2:SetReset(RESET_CHAIN)
				tc:RegisterEffect(e2)
			end
			reset[tc][1]=e2
		end
		goto start
	::jump::
	Duel.SetTargetCard(sg)
	for _,t in ipairs(reset) do
		t[0]:Reset()
		if t[1] then t[1]:Reset() end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511015134.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_XYZ_LEVEL)
		e1:SetValue(tc:GetRank()+1)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		if tc:IsControler(1-tp) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_XYZ_MATERIAL)
			e2:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e2)
		end
		tc=g:GetNext()
	end
	local xyzg=Duel.GetMatchingGroup(c511015134.xyzfilter,tp,LOCATION_EXTRA,0,nil,g,e,tp)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
		xyz:RegisterFlagEffect(511015134,RESET_EVENT+0x1fe0000,0,0)
	end
end
