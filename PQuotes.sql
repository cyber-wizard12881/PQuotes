CREATE OR REPLACE FUNCTION pquote(s text)
RETURNS text
AS $$
import random
from fuzzywuzzy import fuzz

quotes = "If you want to achieve greatness stop asking for permission. ~Anonymous\n" \
"Things work out best for those who make the best of how things work out. ~John Wooden\n" \
"To live a creative life, we must lose our fear of being wrong. ~Anonymous\n" \
"If you are not willing to risk the usual you will have to settle for the ordinary. ~Jim Rohn\n" \
"Trust because you are willing to accept the risk, not because it's safe or certain. ~Anonymous\n" \
"Take up one idea. Make that one idea your life - think of it, dream of it, live on that idea. Let the brain, muscles, nerves, every part of your body, be full of that idea, and just leave every other idea alone. This is the way to success. ~Swami Vivekananda\n" \
"All our dreams can come true if we have the courage to pursue them. ~Walt Disney\n" \
"Good things come to people who wait, but better things come to those who go out and get them. ~Anonymous\n" \
"If you do what you always did, you will get what you always got. ~Anonymous\n" \
"Success is walking from failure to failure with no loss of enthusiasm. ~Winston Churchill\n" \
"Just when the caterpillar thought the world was ending, he turned into a butterfly. ~Proverb\n" \
"Successful entrepreneurs are givers and not takers of positive energy. ~Anonymous\n" \
"Whenever you see a successful person you only see the public glories, never the private sacrifices to reach them. ~Vaibhav Shah\n" \
"Opportunities don't happen, you create them. ~Chris Grosser\n" \
"Try not to become a person of success, but rather try to become a person of value. ~Albert Einstein\n" \
"Great minds discuss ideas; average minds discuss events; small minds discuss people. ~Eleanor Roosevelt\n" \
"I have not failed. I've just found 10,000 ways that won't work. ~Thomas A. Edison\n" \
"If you don't value your time, neither will others. Stop giving away your time and talents- start charging for it. ~Kim Garst\n" \
"A successful man is one who can lay a firm foundation with the bricks others have thrown at him. ~David Brinkley\n" \
"No one can make you feel inferior without your consent. ~Eleanor Roosevelt\n" \
"The whole secret of a successful life is to find out what is one's destiny to do, and then do it. ~Henry Ford\n" \
"If you're going through hell keep going. ~Winston Churchill\n" \
"The ones who are crazy enough to think they can change the world, are the ones that do. ~Anonymous\n" \
"Don't raise your voice, improve your argument. ~Anonymous\n" \
"What seems to us as bitter trials are often blessings in disguise.~ Oscar Wilde\n" \
"The meaning of life is to find your gift. The purpose of life is to give it away. ~Anonymous\n" \
"The distance between insanity and genius is measured only by success. ~Bruce Feirstein\n" \
"When you stop chasing the wrong things you give the right things a chance to catch you. ~Lolly Daskal\n" \
"Don't be afraid to give up the good to go for the great. ~John D. Rockefeller\n" \
"No masterpiece was ever created by a lazy artist.~ Anonymous\n" \
"Happiness is a butterfly, which when pursued, is always beyond your grasp, but which, if you will sit down quietly, may alight upon you. ~Nathaniel Hawthorne\n" \
"If you can't explain it simply, you don't understand it well enough. ~Albert Einstein\n" \
"Blessed are those who can give without remembering and take without forgetting. ~Anonymous\n" \
"Do one thing every day that scares you. ~Anonymous\n" \
"What's the point of being alive if you don't at least try to do something remarkable. ~Anonymous\n" \
"Life is not about finding yourself. Life is about creating yourself. ~Lolly Daskal\n" \
"Nothing in the world is more common than unsuccessful people with talent. ~Anonymous\n" \
"Knowledge is being aware of what you can do. Wisdom is knowing when not to do it. ~Anonymous\n" \
"Your problem isn't the problem. Your reaction is the problem. ~Anonymous\n" \
"You can do anything, but not everything. ~Anonymous\n" \
"Innovation distinguishes between a leader and a follower. ~Steve Jobs\n" \
"There are two types of people who will tell you that you cannot make a difference in this world: those who are afraid to try and those who are afraid you will succeed. ~Ray Goforth\n" \
"Thinking should become your capital asset, no matter whatever ups and downs you come across in your life. ~Dr. APJ Kalam\n" \
"I find that the harder I work, the more luck I seem to have. ~Thomas Jefferson\n" \
"The starting point of all achievement is desire. ~Napolean Hill\n" \
"Success is the sum of small efforts, repeated day-in and day-out. ~Robert Collier\n" \
"If you want to achieve excellence, you can get there today. As of this second, quit doing less-than-excellent work. ~Thomas J. Watson\n" \
"All progress takes place outside the comfort zone. ~Michael John Bobak\n" \
"You may only succeed if you desire succeeding; you may only fail if you do not mind failing. ~Philippos\n" \
"Courage is resistance to fear, mastery of fear - not absense of fear. ~Mark Twain\n" \
"Only put off until tomorrow what you are willing to die having left undone. ~Pablo Picasso\n" \
"People often say that motivation doesn't last. Well, neither does bathing - that's why we recommend it daily. ~Zig Ziglar\n" \
"We become what we think about most of the time, and that's the strangest secret. ~Earl Nightingale\n" \
"The only place where success comes before work is in the dictionary. ~Vidal Sassoon\n" \
"The best reason to start an organization is to make meaning; to create a product or service to make the world a better place. ~Guy Kawasaki\n" \
"I find that when you have a real interest in life and a curious life, that sleep is not the most important thing. ~Martha Stewart\n" \
"It's not what you look at that matters, it's what you see. ~Anonymous\n" \
"The road to success and the road to failure are almost exactly the same. ~Colin R. Davis\n" \
"The function of leadership is to produce more leaders, not more followers. ~Ralph Nader\n" \
"Success is liking yourself, liking what you do, and liking how you do it. ~Maya Angelou\n" \
"As we look ahead into the next century, leaders will be those who empower others. ~Bill Gates\n" \
"A real entrepreneur is somebody who has no safety net underneath them. ~Henry Kravis\n" \
"The first step toward success is taken when you refuse to be a captive of the environment in which you first find yourself. ~Mark Caine\n" \
"People who succeed have momentum. The more they succeed, the more they want to succeed, and the more they find a way to succeed. Similarly, when someone is failing, the tendency is to get on a downward spiral that can even become a self-fulfilling prophecy. ~Tony Robbins\n" \
"When I dare to be powerful - to use my strength in the service of my vision, then it becomes less and less important whether I am afraid. ~Audre Lorde\n" \
"Whenever you find yourself on the side of the majority, it is time to pause and reflect. ~Mark Twain\n" \
"The successful warrior is the average man, with laser-like focus. ~Bruce Lee\n" \
"Take up one idea. Make that one idea your life -- think of it, dream of it, live on that idea. Let the brain, muscles, nerves, every part of your body, be full of that idea, and just leave every other idea alone. This is the way to success. ~Swami Vivekananda\n" \
"Develop success from failures. Discouragement and failure are two of the surest stepping stones to success. ~Dale Carnegie\n" \
"If you don't design your own life plan, chances are you'll fall into someone else's plan. And guess what they have planned for you? Not much. ~ Jim Rohn\n" \
"If you genuinely want something, don't wait for it -- teach yourself to be impatient. ~Gurbaksh Chahal\n" \
"Don't let the fear of losing be greater than the excitement of winning. ~Robert Kiyosaki\n" \
"If you want to make a permanent change, stop focusing on the size of your problems and start focusing on the size of you! ~T. Harv Eker\n" \
"You can't connect the dots looking forward; you can only connect them looking backwards. So you have to trust that the dots will somehow connect in your future. You have to trust in something - your gut, destiny, life, karma, whatever. This approach has never let me down, and it has made all the difference in my life. ~Steve Jobs\n" \
"Successful people do what unsuccessful people are not willing to doDon't wish it were easier, wish you were better. ~Jim Rohn\n" \
"The number one reason people fail in life is because they listen to their friends, family, and neighbors. ~Napoleon Hill\n" \
"The reason most people never reach their goals is that they don't define them, or ever seriously consider them as believable or achievable. Winners can tell you where they are going, what they plan to do along the way, and who will be sharing the adventure with them. ~Denis Watiley\n" \
"In my experience, there is only one motivation, and that is desire. No reasons or principle contain it or stand against it. ~Jane Smiley\n" \
"Success does not consist in never making mistakes but in never making the same one a second time. ~George Bernard Shaw\n" \
"I don't want to get to the end of my life and find that I lived just the length of it. I want to have lived the width of it as well. ~Diane Ackerman\n" \
"You must expect great things of yourself before you can do them. ~Michael Jordan\n" \
"Motivation is what gets you started. Habit is what keeps you going. ~Jim Ryun\n" \
"People rarely succeed unless they have fun in what they are doing. ~Dale Carnegie\n" \
"There is no chance, no destiny, no fate, that can hinder or control the firm resolve of a determined soul. ~Ella Wheeler Wilcox\n" \
"Our greatest fear should not be of failure but of succeeding at things in life that don't really matter. ~Francis Chan\n" \
"You've got to get up every morning with determination if you're going to go to bed with satisfaction. ~George Lorimer\n" \
"To be successful you must accept all challenges that come your way. You can't just accept the ones you like. ~Mike Gafka\n" \
"Success is...knowing your purpose in life, growing to reach your maximum potential, and sowing seeds that benefit others. ~ John C. Maxwell\n" \
"Be miserable. Or motivate yourself. Whatever has to be done, it's always your choice. ~Wayne Dyer\n" \
"To accomplish great things, we must not only act, but also dream, not only plan, but also believe.~ Anatole France\n" \
"Most of the important things in the world have been accomplished by people who have kept on trying when there seemed to be no help at all. ~Dale Carnegie\n" \
"You measure the size of the accomplishment by the obstacles you had to overcome to reach your goals. ~Booker T. Washington\n" \
"Real difficulties can be overcome; it is only the imaginary ones that are unconquerable. ~Theodore N. Vail\n" \
"It is better to fail in originality than to succeed in imitation. ~Herman Melville\n" \
"Fortune sides with him who dares. ~Virgil\n" \
"Little minds are tamed and subdued by misfortune; but great minds rise above it. ~Washington Irving\n" \
"Failure is the condiment that gives success its flavor. ~Truman Capote\n" \
"Don't let what you cannot do interfere with what you can do. ~John R. Wooden\n" \
"You may have to fight a battle more than once to win it. ~Margaret Thatcher\n" \
""

qs = quotes.split("\n")
random.shuffle(qs)

p_max = -1
q_max = ""

for q in qs:
   p = fuzz.partial_token_sort_ratio(q, s)
   if p > p_max:
       p_max = p
       q_max = q

return q_max

$$ LANGUAGE plpython3u;