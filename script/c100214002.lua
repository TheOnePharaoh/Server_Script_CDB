--EMバラクーダ
--Performapal Barracuda
--Scripted by Eerie Code
function c100214002.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--reduce atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100214002,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c100214002.atkcon1)
	e1:SetOperation(c100214002.atkop1)
	c:RegisterEffect(e1)
	--increase atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100214002,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100214002)
	e2:SetTarget(c100214002.atktg2)
	e2:SetOperation(c100214002.atkop2)
	c:RegisterEffect(e2)
end
function c100214002.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then bc,tc=tc,bc end
	e:SetLabelObject(bc)
	return bc:IsFaceup() and tc:IsFaceup() and tc:IsSetCard(0x9f) and bc:GetBaseAttack()~=bc:GetAttack()
end
function c100214002.atkop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() and bc:IsFaceup() and bc:IsControler(1-tp) then
		local diff=math.abs(bc:GetBaseAttack()-bc:GetAttack())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-diff)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e1)
	end
end
function c100214002.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9f) and c:GetBaseAttack()~=c:GetAttack()
end
function c100214002.atktg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100214002.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100214002.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c100214002.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100214002.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local diff=math.abs(tc:GetBaseAttack()-tc:GetAttack())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(diff)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end