INSPO=(
  'Travel light through life. Keep only what you need.'
  'If you’re going to curse, be clever. If you’re going to curse in public, know your audience.'
  'Seek out the people and places that resonate with your soul.'
  'Just because you can, doesn’t mean you should.'
  'Happiness is not a permanent state. Wholeness is. Don’t confuse these.'
  'Can’t is a cop-out.'
  'Hold your heroes to a high standard. Be your own hero.'
  'Never lie to yourself.'
  'Your body, your rules.'
  'If you have an opinion, you better know why.'
  'Practice your passions.'
  'Ask for what you want. The worst thing they can say is no.'
  'Wish on stars, then get to work to make them happen.'
  'Stay as sweet as you are.'
  'Fall in love often. Particularly with ideas, art, music, literature, food and far-off places.'
  'Reserve “I’m sorry” for when you truly are.'
  'Question everything, except your own intuition.'
  'You have enough. You are enough.'
  'Say what you mean and mean what you say.'
  'Be kind; treat others how you would like them to treat you.'
  'Own the game, and win every time.'
  'Always keep moving forward. Never look back'
)
rand=$[ $RANDOM % ${#INSPO[@]} ]

RANDOM_INSPO=${INSPO[$rand]}

echo $RANDOM_INSPO
