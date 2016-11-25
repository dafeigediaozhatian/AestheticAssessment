function emotiondim = emotion(f)
% EMOTION calculate the emotional dimension (pleasure, arousal, dominance) 
% using average v and average s. f is the input rgb image

hsv = averagehsv(f);

pleasure = 0.69*hsv(3)+0.22*hsv(2);
arousal = -0.31*hsv(3)+0.6*hsv(2);
dominance = 0.76*hsv(3)+0.32*hsv(2);
emotiondim = [pleasure,arousal,dominance];