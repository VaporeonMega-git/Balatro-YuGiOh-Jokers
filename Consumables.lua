SMODS.Consumable {
  key = "graceful_charity",
  set = "spell",
  loc_txt = {
    name = 'Graceful Charity',
    text = {
      "Discard #1# cards",
      "and draw #2#"
    }
  },
  loc_vars = function(self, info_queue, center)
    return {vars = {2, 3}}
  end,
  atlas = 'YGOSpells',
  pos = {x = 0, y = 0},
  cost = 2,
  can_use = function(self, card)
    if #G.hand.highlighted == 2 then
      return true
    else
      return false
    end
  end,
  use = function(self, card, area, copier)
    G.FUNCS.discard_cards_from_highlighted(nil, true)
    G.FUNCS.draw_from_deck_to_hand(3)
  end
}

-- SMODS.Consumable {
--   key = "graceful_charity",
--   set = "spell",
--   loc_txt = {
--     name = 'Graceful Charity',
--     text = {
--       "Grants a free shop reroll"
--     }
--   },
--   loc_vars = function(self, info_queue, center)
--     return {vars = {}}
--   end,
--   atlas = 'YGOSpells',
--   pos = {x = 0, y = 0},
--   cost = 2,
--   can_use = function(self, card)
--     return true
--   end,
--   use = function(self, card, area, copier)
--     G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + 1
--     calculate_reroll_cost(true)
--   end
-- }

SMODS.Consumable {
  key = "pot_of_greed",
  set = "spell",
  loc_txt = {
    name = 'Pot Of Greed',
    text = {
      "Draw #1# cards"
    }
  },
  loc_vars = function(self, info_queue, center)
    return {vars = {2}}
  end,
  atlas = 'YGOSpells',
  pos = {x = 1, y = 0},
  cost = 8,
  can_use = function(self, card)
    if G.GAME.facing_blind then
      return true
    elseif G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK then
      return true
    else
      return false
    end
  end,
  use = function(self, card, area, copier)
      G.FUNCS.draw_from_deck_to_hand(2)
  end
}

SMODS.Consumable {
  key = "enemy_controller",
  set = "spell",
  loc_txt = {
    name = 'Enemy Controller',
    text = {
      "Remove eternal, perishable,",
      "and rental from 1 selected joker"
    }
  },
  loc_vars = function(self, info_queue, center)
    return {vars = {2, 3}}
  end,
  atlas = 'YGOSpells',
  pos = {x = 2, y = 0},
  cost = 2,
  can_use = function(self, card)
    if #G.jokers.highlighted == 1 then
      return true
    else
      return false
    end
  end,
  use = function(self, card, area, copier)
    G.jokers.highlighted[1]:set_eternal(false)
    G.jokers.highlighted[1].ability.perishable = nil
    G.jokers.highlighted[1]:set_rental(false)
  end
}

SMODS.Consumable {
  key = "mystical_space_typhoon",
  set = "spell",
  loc_txt = {
    name = 'Mystical Space Typhoon',
    text = {
      "Destroy #1# playing card"
    }
  },
  loc_vars = function(self, info_queue, center)
    return {vars = {1}}
  end,
  atlas = 'YGOSpells',
  pos = {x = 3, y = 0},
  cost = 2,
  can_use = function(self, card)
    if #G.hand.highlighted == 1 then
      return true
    else
      return false
    end
  end,
  use = function(self, card, area, copier)
    local destroyed_cards = {G.hand.highlighted[1]}
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
      play_sound('tarot1')
      card:juice_up(0.3, 0.5)
      return true end }))
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.2,
      func = function() 
        G.hand.highlighted[1]:start_dissolve(nil, i == #G.hand.highlighted)
        return true end }))
    delay(0.3)
    for i = 1, #G.jokers.cards do
        G.jokers.cards[i]:calculate_joker({remove_playing_cards = true, removed = destroyed_cards})
    end
  end
}