/// The time an admin has to cancel a cross-sector message
#define CROSS_SECTOR_CANCEL_TIME (10 SECONDS)

//Severity codes, These are mostly a legacy support thing.
/// Probably green. Shit is okay.
#define SECLEVEL_SEVERITY_NEUTRAL 0
/// Ex: Blue. Shit isn't okay.
#define SECLEVEL_SEVERITY_MINOR 1
/// Ex: Red. Shit is bad.
#define SECLEVEL_SEVERITY_MAJOR 2
/// Ex: Delta. Shit Is Fucked:tm:
#define SECLEVEL_SEVERITY_FUCKED 3
/// Ex: Hehehehehehehehehehehehe
#define SECLEVEL_SEVERITY_APOCALYPTIC 4

// Security level "feature" flags, These are just defined vars for use in SSsecurity_level.check_feature(feature)
#define SEC_FEATURE_NO_SHUTTLECALL_REASON "allow_reasonless_shuttlecall"
