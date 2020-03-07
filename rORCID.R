library(rorcid)

# Authenticate API
orcid_auth()

# Profile
out <- orcid_id(orcid = "0000-0002-0559-5176")

# Works
works <- works("0000-0002-0559-5176")

# Qualifications
qual <- orcid_qualifications("0000-0002-0559-5176")

# Employment
empl <- orcid_employments("0000-0002-0559-5176")

# Education
educ <- orcid_educations("0000-0002-0559-5176")
