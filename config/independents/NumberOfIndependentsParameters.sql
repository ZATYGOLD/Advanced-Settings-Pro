-- config/independents/NumberOfIndependentsParameters.sql
-- Author: Zatygold

-- Independent Count Settings
-- Left Side | Setting Title Information
INSERT OR IGNORE INTO Parameters (ParameterID, Name, Description, Domain, DefaultValue, Hash, ConfigurationGroup, ConfigurationKey,	GroupId, ChangeableAfterGameStart, SortIndex) 
    VALUES ("ZG_IndependentCount", "LOC_ZG_INDEPENDENT_COUNT_NAME", "LOC_ZG_INDEPENDENT_COUNT_DESCRIPTION", 
            "ZG_IndependentCountDomain", "ZG_DEFAULT_INDEPENDENTS", "1", "Game","IndependentCountKey" , "GameOptions", "0", "149");

-- Right Side | Setting Options, Description, and Additional Information
INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_IndependentCountDomain", "ZG_DEFAULT_INDEPENDENTS", "LOC_ZG_DEFAULT_NAME", "", 10);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_IndependentCountDomain", "ZG_MORE_INDEPENDENTS", "LOC_ZG_MORE_NAME", "", 20);

INSERT OR IGNORE INTO DomainValues (Domain, Value, Name, Description, SortIndex)
    VALUES ("ZG_IndependentCountDomain", "ZG_LESS_INDEPENDENTS", "LOC_ZG_LESS_NAME", "", 30);