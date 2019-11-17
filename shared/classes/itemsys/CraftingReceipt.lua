CraftingReceipt = inherit(Object)

function CraftingReceipt:constructor(receiptId, skillRequired, category, secret, rewardItem, rewardAmount,
                                    requiredItem1, requiredAmount1, requiredItem2, requiredAmount2, requiredItem3, requiredAmount3,
                                    requiredItem4, requiredAmount4, requiredItem5, requiredAmount5, requiredItem6, requiredAmount6 )

    self.m_ReceiptId = receiptId
    self.m_SkillRequired = skillRequired
    self.m_Category = category
    self.m_RewardItem = rewardItem
    self.m_RewardAmount = rewardAmount
    self.m_Secret = secret == 1

    self.m_RequiredItems = {}

    for i = 1, 6, 1 do self.m_RequiredItems[i] = {} end

    self.m_RequiredItems[1].Item   = requiredItem1
    self.m_RequiredItems[1].Amount = requiredAmount1
    self.m_RequiredItems[2].Item   = requiredItem2
    self.m_RequiredItems[2].Amount = requiredAmount2
    self.m_RequiredItems[3].Item   = requiredItem3
    self.m_RequiredItems[3].Amount = requiredAmount3
    self.m_RequiredItems[4].Item   = requiredItem4
    self.m_RequiredItems[4].Amount = requiredAmount4
    self.m_RequiredItems[5].Item   = requiredItem5
    self.m_RequiredItems[5].Amount = requiredAmount5
    self.m_RequiredItems[6].Item   = requiredItem6
    self.m_RequiredItems[6].Amount = requiredAmount6
end

function CraftingReceipt:getCategory() return self.m_Category end
function CraftingReceipt:getRewardItem() return self.m_RewardItem end
function CraftingReceipt:getRewardAmount() return self.m_RewardAmount end
function CraftingReceipt:getReceiptId() return self.m_ReceiptId end
function CraftingReceipt:getSkillRequirement() return self.m_SkillRequired end
function CraftingReceipt:isSecret() return self.m_Secret end

function CraftingReceipt:getRequiredItems()
    return self.m_RequiredItems
end