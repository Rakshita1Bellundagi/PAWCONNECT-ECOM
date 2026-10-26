-- =============================================
-- PawConnect Database Upgrade Script
-- Phase 2 & 3: More pets + Care Guide columns
-- Run this in MySQL Workbench BEFORE Clean and Build
-- =============================================

-- Add new columns for care guide and second image
ALTER TABLE pets ADD COLUMN image_url_2 VARCHAR(255) DEFAULT NULL;
ALTER TABLE pets ADD COLUMN care_guide TEXT DEFAULT NULL;
ALTER TABLE pets ADD COLUMN food_guide TEXT DEFAULT NULL;
ALTER TABLE pets ADD COLUMN health_tips TEXT DEFAULT NULL;
ALTER TABLE pets ADD COLUMN do_list TEXT DEFAULT NULL;
ALTER TABLE pets ADD COLUMN dont_list TEXT DEFAULT NULL;

-- Add location columns for users
ALTER TABLE users ADD COLUMN latitude DOUBLE DEFAULT NULL;
ALTER TABLE users ADD COLUMN longitude DOUBLE DEFAULT NULL;

-- =============================================
-- Update existing pets with care guide data
-- =============================================

-- Golden Retriever
UPDATE pets SET 
    care_guide = 'Golden Retrievers are friendly, intelligent, and devoted dogs. They need daily exercise (1-2 hours), regular grooming, and lots of social interaction. They are prone to hip dysplasia and should have regular vet check-ups. Keep them mentally stimulated with training and interactive toys.',
    food_guide = 'Feed 2-3 cups of high-quality dry dog food daily, divided into two meals. Include lean proteins (chicken, fish), whole grains, and vegetables. Avoid chocolate, grapes, onions, and garlic. Ensure fresh water is always available. Consider omega-3 supplements for coat health.',
    health_tips = 'Regular vet visits every 6 months. Keep vaccinations up to date. Watch for signs of hip dysplasia, elbow dysplasia, and eye conditions. Maintain a healthy weight to prevent joint issues. Regular dental cleaning is important.',
    do_list = 'Provide daily exercise and walks|Brush coat 2-3 times per week|Socialize with other dogs and people|Train using positive reinforcement|Regular vet check-ups|Provide mental stimulation with puzzles|Keep nails trimmed regularly',
    dont_list = 'Do not leave alone for long periods|Do not overfeed - they are prone to obesity|Do not skip grooming sessions|Do not use harsh training methods|Do not ignore signs of limping or discomfort|Do not feed human junk food'
WHERE pet_name LIKE '%Golden%' OR pet_name LIKE '%golden%';

-- Labrador
UPDATE pets SET 
    care_guide = 'Labradors are energetic, outgoing, and friendly. They require at least 1-2 hours of exercise daily. Regular grooming helps manage their double coat shedding. They are excellent family dogs but need consistent training from an early age.',
    food_guide = 'Feed 2.5-3 cups of premium dog food daily in two meals. Labs love to eat and are prone to obesity, so portion control is crucial. Include fish oil for coat health. Avoid table scraps and high-fat treats.',
    health_tips = 'Watch for hip and elbow dysplasia. Labs are prone to obesity - monitor weight closely. Regular eye exams recommended. Keep ears clean and dry to prevent infections. Exercise regularly to maintain joint health.',
    do_list = 'Provide plenty of exercise and swimming|Keep a consistent feeding schedule|Train early and consistently|Socialize with children and other pets|Regular grooming and brushing|Provide chew toys for dental health',
    dont_list = 'Do not overfeed - Labs will eat anything|Do not skip daily exercise|Do not leave without mental stimulation|Do not ignore ear infections|Do not let them become overweight'
WHERE pet_name LIKE '%Labrador%' OR pet_name LIKE '%labrador%';

-- Beagle
UPDATE pets SET 
    care_guide = 'Beagles are curious, friendly, and merry hounds. They have an exceptional sense of smell and love to explore. Regular exercise is essential - at least 1 hour daily. They can be vocal, so training to manage barking is recommended.',
    food_guide = 'Feed 1-1.5 cups of quality dog food daily. Beagles are food-driven and prone to obesity. Use small treats for training. Include protein-rich foods and avoid excessive carbs. Fresh water always available.',
    health_tips = 'Watch for epilepsy, hypothyroidism, and cherry eye. Regular ear cleaning is crucial due to floppy ears. Dental care is important. Keep vaccinations current and maintain flea/tick prevention.',
    do_list = 'Keep on a leash outdoors (strong scent drive)|Provide plenty of sniffing activities|Regular ear cleaning|Consistent training with food rewards|Daily exercise and play sessions',
    dont_list = 'Never let off-leash in unfenced areas|Do not ignore excessive barking|Do not leave food within reach|Do not skip ear cleaning|Do not overfeed'
WHERE pet_name LIKE '%Beagle%' OR pet_name LIKE '%beagle%';

-- Persian Cat
UPDATE pets SET 
    care_guide = 'Persian cats are calm, gentle, and affectionate. Their long, luxurious coat requires daily grooming. They prefer a quiet, stable environment. Regular eye cleaning is needed due to their flat face structure.',
    food_guide = 'Feed high-quality cat food 2-3 times daily. Wet food helps with hydration. Include taurine-rich foods for heart and eye health. Avoid milk (most cats are lactose intolerant). Provide fresh water with a fountain if possible.',
    health_tips = 'Daily eye cleaning due to tear staining. Watch for polycystic kidney disease (PKD). Regular dental check-ups. Monitor breathing as they are a brachycephalic breed. Keep indoor to prevent coat matting.',
    do_list = 'Brush coat daily to prevent matting|Clean eyes daily|Provide quiet, calm environment|Regular vet check-ups|Keep litter box clean|Provide scratching posts',
    dont_list = 'Do not skip daily grooming|Do not expose to extreme heat|Do not let outdoors unsupervised|Do not use harsh shampoos|Do not ignore breathing difficulties'
WHERE pet_name LIKE '%Persian%' OR pet_name LIKE '%persian%';

-- Siamese Cat
UPDATE pets SET 
    care_guide = 'Siamese cats are social, vocal, and intelligent. They crave human interaction and can become depressed if left alone. They are active and playful, needing interactive toys and climbing structures. Short coat requires minimal grooming.',
    food_guide = 'Feed premium cat food 2-3 times daily. Include high-protein, low-carb diet. Wet food recommended for hydration. Taurine supplements beneficial. Avoid dairy products.',
    health_tips = 'Watch for respiratory issues and dental problems. Regular vet visits recommended. Monitor for progressive retinal atrophy. Keep vaccinations up to date. Maintain healthy weight.',
    do_list = 'Provide lots of social interaction|Interactive toys and puzzles|Climbing structures and cat trees|Regular playtime sessions|Routine vet check-ups',
    dont_list = 'Do not leave alone for extended periods|Do not ignore vocalization changes|Do not overfeed|Do not skip dental care|Do not expose to cold drafts'
WHERE pet_name LIKE '%Siamese%' OR pet_name LIKE '%siamese%';

-- Macaw / Birds
UPDATE pets SET 
    care_guide = 'Macaws are intelligent, colorful, and social birds that can live 50+ years. They need a large cage, daily out-of-cage time, and lots of interaction. They can learn to talk and perform tricks with patient training.',
    food_guide = 'Feed a varied diet of pellets (60%), fresh fruits and vegetables (30%), and seeds/nuts (10%). Offer apples, bananas, carrots, and leafy greens daily. Avoid avocado, chocolate, caffeine, and alcohol - these are toxic to birds.',
    health_tips = 'Regular avian vet check-ups annually. Watch for feather plucking (sign of stress). Ensure adequate vitamin D through sunlight or UV lamps. Keep environment draft-free. Monitor droppings for health changes.',
    do_list = 'Provide large cage with toys|Daily out-of-cage exercise|Social interaction and talking|Fresh fruits and veggies daily|Regular beak and nail trimming|Clean cage daily',
    dont_list = 'Do not use non-stick cookware near birds|Do not expose to aerosols or smoke|Do not feed avocado or chocolate|Do not leave unsupervised with other pets|Do not neglect social interaction'
WHERE pet_name LIKE '%Macaw%' OR pet_name LIKE '%macaw%' OR pet_name LIKE '%African Grey%';

-- Budgie / Small Birds  
UPDATE pets SET 
    care_guide = 'Budgies are small, social parakeets that make wonderful pets. They are intelligent and can learn words and tricks. Keep in pairs if possible. Provide a spacious cage with perches at different levels and toys for mental stimulation.',
    food_guide = 'Feed quality seed mix supplemented with fresh vegetables (spinach, carrots, broccoli) and fruits (apple, banana). Provide cuttlebone for calcium. Fresh, clean water daily. Avoid avocado, chocolate, and caffeine.',
    health_tips = 'Watch for respiratory issues and scaly face mites. Keep cage clean to prevent infections. Monitor weight and droppings. Annual vet check-ups recommended. Ensure proper ventilation without drafts.',
    do_list = 'Keep in pairs for companionship|Provide variety of perches|Fresh food and water daily|Regular cage cleaning|Allow supervised flight time',
    dont_list = 'Do not keep in drafty areas|Do not use scented candles near cage|Do not feed avocado|Do not keep cage in kitchen|Do not grab or chase the bird'
WHERE pet_name LIKE '%Budgie%' OR pet_name LIKE '%budgie%' OR pet_name LIKE '%Cockatiel%' OR pet_name LIKE '%Canary%' OR pet_name LIKE '%Lovebird%';

-- Goldfish / Fish
UPDATE pets SET 
    care_guide = 'Goldfish are hardy freshwater fish that can live 10-15 years with proper care. They need a minimum 20-gallon tank (not a bowl!). Regular water changes (25% weekly) are essential. They are social and do best with tank mates.',
    food_guide = 'Feed high-quality goldfish pellets or flakes 2-3 times daily. Only give what they can eat in 2 minutes. Supplement with blanched vegetables (peas, lettuce). Avoid overfeeding as it pollutes the water.',
    health_tips = 'Monitor water temperature (65-75°F). Test water parameters weekly (pH, ammonia, nitrites). Watch for white spots (ich), fin rot, or swim bladder issues. Quarantine new fish before adding to tank.',
    do_list = 'Regular water changes (25% weekly)|Test water parameters regularly|Provide adequate filtration|Feed measured portions|Maintain consistent temperature|Add live plants for enrichment',
    dont_list = 'Do not keep in a bowl - needs proper tank|Do not overfeed|Do not change all water at once|Do not mix with tropical fish|Do not place tank in direct sunlight|Do not use soap to clean tank'
WHERE pet_name LIKE '%Goldfish%' OR pet_name LIKE '%goldfish%' OR pet_name LIKE '%Betta%' OR pet_name LIKE '%Angelfish%' OR pet_name LIKE '%Clownfish%';

-- Hamster
UPDATE pets SET 
    care_guide = 'Hamsters are nocturnal, solitary animals that make great first pets. They need a spacious cage with bedding, an exercise wheel, and hiding spots. Handle gently and regularly for socialization. Most hamsters prefer to live alone.',
    food_guide = 'Feed commercial hamster pellets as the base diet. Supplement with small amounts of fresh vegetables (broccoli, carrots, cucumber) and occasional fruits (apple, banana). Provide fresh water in a bottle. Avoid citrus, onions, and garlic.',
    health_tips = 'Watch for wet tail (diarrhea), respiratory issues, and dental problems. Keep cage clean and dry. Provide chew toys for dental health. Monitor for signs of stress (bar chewing, excessive grooming). Lifespan is 2-3 years.',
    do_list = 'Provide exercise wheel (solid surface)|Clean cage weekly|Handle gently and regularly|Provide hiding spots and tunnels|Fresh food and water daily|Chew toys for dental health',
    dont_list = 'Do not wake during daytime sleep|Do not house together (Syrian hamsters)|Do not use cedar or pine bedding|Do not bathe in water|Do not place cage in direct sunlight|Do not feed sticky foods'
WHERE pet_name LIKE '%Hamster%' OR pet_name LIKE '%hamster%';

-- Rabbit
UPDATE pets SET 
    care_guide = 'Rabbits are social, intelligent animals that need daily exercise and interaction. They can be litter trained and enjoy free-roaming in bunny-proofed areas. Provide unlimited hay, fresh water, and a spacious enclosure.',
    food_guide = 'Unlimited timothy hay (80% of diet) is essential for digestive health. Supplement with fresh leafy greens (romaine, cilantro, parsley) and a small amount of pellets. Treats like banana or apple in very small portions. Fresh water always available.',
    health_tips = 'Watch for GI stasis (not eating/pooping). Regular dental check-ups as teeth grow continuously. Spay/neuter for health benefits. Monitor for ear mites and respiratory issues. Keep nails trimmed.',
    do_list = 'Provide unlimited timothy hay|Daily exercise outside enclosure|Bunny-proof play areas|Regular nail trimming|Social interaction daily|Keep in pairs when possible',
    dont_list = 'Do not feed iceberg lettuce|Do not pick up by ears ever|Do not keep in small cage only|Do not use wire-bottom cages|Do not bathe unless absolutely necessary|Do not feed too many pellets'
WHERE pet_name LIKE '%Holland%' OR pet_name LIKE '%Netherland%' OR pet_name LIKE '%rabbit%' OR pet_name LIKE '%Rabbit%';

-- Guinea Pig
UPDATE pets SET 
    care_guide = 'Guinea pigs are gentle, social animals that thrive in pairs. They need a spacious cage, daily vitamin C, and regular interaction. They communicate through various sounds and enjoy being handled gently.',
    food_guide = 'Feed unlimited timothy hay, fresh vegetables rich in vitamin C (bell peppers, kale, broccoli), and quality guinea pig pellets. Fresh water daily. They cannot produce their own vitamin C, so supplementation is crucial.',
    health_tips = 'Monitor for vitamin C deficiency (scurvy). Watch for respiratory infections, dental problems, and bumblefoot. Regular nail trimming needed. Keep cage dry and clean. Lifespan 5-7 years with proper care.',
    do_list = 'Keep in pairs or groups|Provide vitamin C daily|Spacious cage with hiding spots|Daily vegetable servings|Regular nail trimming|Gentle handling sessions',
    dont_list = 'Do not keep alone|Do not house with rabbits|Do not feed rabbit pellets (no vitamin C)|Do not use exercise balls|Do not expose to extreme temperatures|Do not use cedar bedding'
WHERE pet_name LIKE '%Guinea%' OR pet_name LIKE '%guinea%';

-- Default for remaining pets (dogs)
UPDATE pets SET 
    care_guide = 'This breed requires regular exercise, balanced nutrition, and consistent veterinary care. Provide a safe, comfortable living environment with proper socialization from a young age. Training should be positive and reward-based.',
    food_guide = 'Feed high-quality dog food appropriate for the breed size and age. Divide daily food into 2 meals. Include lean proteins, healthy fats, and complex carbohydrates. Always provide fresh, clean water. Consult your vet for specific dietary needs.',
    health_tips = 'Regular vet check-ups every 6 months. Keep vaccinations and deworming up to date. Maintain dental hygiene with dental chews and regular brushing. Monitor for breed-specific health concerns. Regular flea and tick prevention.',
    do_list = 'Daily exercise appropriate for breed|Regular grooming and bathing|Positive reinforcement training|Socialization with people and pets|Routine vet visits|Fresh water always available|Mental stimulation with toys',
    dont_list = 'Do not skip vaccinations|Do not overfeed|Do not use physical punishment|Do not leave in hot cars|Do not ignore changes in behavior|Do not feed toxic foods (chocolate, grapes, onions)'
WHERE care_guide IS NULL;
