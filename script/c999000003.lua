--Majestic Life Dragon
--AlphaKretin
function c999000003.initial_effect(c)
	--sinklo shokan
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c999000003.syncon)
	e1:SetOperation(c999000003.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--change lp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999000003,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c999000003.lpcon)
	e2:SetOperation(c999000003.lpop)
	c:RegisterEffect(e2)
	--Disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999000003,1))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c999000003.distg)
	e3:SetOperation(c999000003.disop)
	c:RegisterEffect(e3)
	--to extra & Special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(999000003,2))
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetTarget(c999000003.sptg)
	e4:SetOperation(c999000003.spop)
	c:RegisterEffect(e4)
end
--Synchro summon
function c999000003.matfilter(c,syncard)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c999000003.synfilter1(c,syncard,lv,g)
	return c:IsCode(21159309) and g:IsExists(c999000003.synfilter2,1,c,syncard,lv,g,c)
end
function c999000003.synfilter2(c,syncard,lv,g,mc)
	if not (c:IsCode(25165047) or c:IsCode(2403771)) then return false end
	--if c:IsType(TYPE_TUNER)==mc:IsType(TYPE_TUNER) then return false end
	local mg=g:Filter(Card.IsNotTuner,nil)
	Duel.SetSelectedCard(Group.FromCards(c,mc))
	return mg:CheckWithSumEqual(Card.GetSynchroLevel,lv,1,1,syncard)
end
function c999000003.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c999000003.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	if tuner then return c999000003.synfilter1(tuner,c,lv,mg) end
	return mg:IsExists(c999000003.synfilter1,1,nil,c,lv,mg)
end
function c999000003.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(c999000003.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	local m1=tuner
	if not tuner then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t1=mg:FilterSelect(tp,c999000003.synfilter1,1,1,nil,c,lv,mg)
		m1=t1:GetFirst()
		g:AddCard(m1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local t2=mg:FilterSelect(tp,c999000003.synfilter2,1,1,m1,c,lv,mg,m1)
	g:Merge(t2)
	local mg2=mg:Filter(Card.IsNotTuner,nil)
	Duel.SetSelectedCard(g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local t3=mg2:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,1,1,c)
	g:Merge(t3)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
--set lp
function c999000003.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c999000003.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,8000)
end
--negate
function c999000003.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c999000003.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return e:GetHandler():GetEquipCount()>0 and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,e:GetHandler():GetEquipCount(),nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c999000003.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	while tc do
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
		tc=g:GetNext()
	end
	
end
--bounce and summon
function c999000003.spfilter(c,e,tp)
	return (c:IsCode(25165047) or c:IsCode(2403771)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999000003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c999000003.spfilter(chkc,e,tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c999000003.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c999000003.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if bit.band(c:GetOriginalType(),0x802040)~=0 and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0
		and c:IsLocation(LOCATION_EXTRA) and tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end