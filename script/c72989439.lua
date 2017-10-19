--カオス・ソルジャー －開闢の使者－
function c72989439.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72989439,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c72989439.spcon)
	e1:SetOperation(c72989439.spop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72989439,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c72989439.rmcost)
	e2:SetTarget(c72989439.rmtg)
	e2:SetOperation(c72989439.rmop)
	c:RegisterEffect(e2)
	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72989439,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c72989439.atcon)
	e3:SetOperation(c72989439.atop)
	c:RegisterEffect(e3)
end
function c72989439.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(c72989439.atchk1,1,nil,sg)
end
function c72989439.atchk1(c,sg)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and sg:FilterCount(Card.IsAttribute,c,ATTRIBUTE_DARK)==1
end
function c72989439.spfilter(c,att)
	return c:IsAttribute(att) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c72989439.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg1=Duel.GetMatchingGroup(c72989439.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,ATTRIBUTE_LIGHT)
	local rg2=Duel.GetMatchingGroup(c72989439.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)
	local rg=rg1:Clone()
	rg:Merge(rg2)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and rg1:GetCount()>0 and rg2:GetCount()>0 
		and aux.SelectUnselectGroup(rg,e,tp,2,2,c72989439.rescon,0)
end
function c72989439.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(c72989439.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,c72989439.rescon,1,tp,HINTMSG_REMOVE)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c72989439.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
	c:RegisterFlagEffect(72989439,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c72989439.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c72989439.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c72989439.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and c:GetFlagEffect(72989439)==0
		and c:IsChainAttackable()
end
function c72989439.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end