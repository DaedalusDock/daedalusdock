#define BLACKBOX_FEEDBACK_NUM(key) (SSblackbox.feedback[key] ? SSblackbox.feedback[key].json["data"] : null)

#define BLACKBOX_FEEDBACK_NESTED_TALLY(key) (SSblackbox.feedback[key] ? SSblackbox.feedback[key].json["data"] : null)
