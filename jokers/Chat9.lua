SMODS.Joker {
    key = "Chat9",
    name = "Chat9",
    atlas = 'Jokers',
    pos = {x = 3,y = 0,},
    rarity = 1,
    cost = 1,
    -- unlocked = true,
    -- discovered = false,
    -- eternal_compat = true,
    -- perishable_compat = true,
    -- blueprint_compat = true,
    config = {
        extra = { mult = 15, odds = 2, cost = -6, count = 0 },
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.mult, G.GAME.probabilities.normal or 1, card.ability.extra.odds}
        }
    end,
	add_to_deck = function(from_debuff, card)
		card:set_cost()
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.selling_self and pseudorandom('adoring'..G.GAME.round_resets.ante) < G.GAME.probabilities.normal / card.ability.extra.odds and card.ability.extra.count < 4 then
			card.ability.extra.count = card.ability.extra.count + 1
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('buf_afan_annoy'..math.random(1,4)), colour = G.C.RED})
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.5,
				func = function() 
					local chosen_joker = nil
					for i = 1, #G.jokers.cards do
						if G.jokers.cards[i] == card then chosen_joker = G.jokers.cards[i] end
					end
					local _card = copy_card(chosen_joker, nil, nil, nil, false)
					_card:add_to_deck()
					G.jokers:emplace(_card)
					_card:start_materialize()
					G.GAME.joker_buffer = 0
					return true
				end
			}))
		elseif context.selling_self and card.ability.extra.count >= 4 then
			SMODS.calculate_effect({message = localize('buf_disilluison'), colour = G.C.BUF_SPC}, card)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.5,
				func = function() 
					SMODS.add_card({key = 'j_buf_afan_spc'})
					return true
				end
			}))
		end
    end
}
