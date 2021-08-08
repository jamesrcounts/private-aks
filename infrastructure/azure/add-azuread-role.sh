#!/usr/bin/env bash
set -euo pipefail

BASE_URL='https://graph.microsoft.com/v1.0'

# Builds the body to post to directoryRoles endpoint to activate a role
activate_directory_role_body () {
    ROLE_TEMPLATE_ID=${1}

    printf '{"roleTemplateId": "%s"}' ${ROLE_TEMPLATE_ID}
}

# Builds the body to post to the directoryRoles member endpoint
add_directory_role_member_body () {
    PRINCIPAL_ID=${1}

    printf '{"@odata.id": "%s/directoryObjects/%s"}' ${BASE_URL} ${PRINCIPAL_ID}
}

# Builds URL for the Graph API directoryRoles endpoint
endpoint_directory_roles () {
    printf "%s" ${BASE_URL} '/directoryRoles'
}

# Builds and formats an oData filter clause
odata_filter () {
    RAW_FILTER=${1}

    FILTER=$(printf "${RAW_FILTER}" | jq -sRr @uri)

    printf '$filter=%s' ${FILTER}
}

# Query the Graph API activated roles and returns the ID for the role matching
# DISPLAY_NAME; otherwise returns null
get_azuread_directory_role () {
    DISPLAY_NAME="${1}"

    SELECT='$select=id'
    FILTER=$(odata_filter "displayName eq '${DISPLAY_NAME}'")

    ENDPOINT_URL=$(endpoint_directory_roles)
    URL=$(printf "%s" ${ENDPOINT_URL} '?' ${SELECT} '&' ${FILTER})
    ROLE_ID=$(az rest --method get --url ${URL} | jq -r '.value[0].id')

    printf ${ROLE_ID}
}

# Query the Graph API role templates and returns the ID for the role template 
# matching DISPLAY_NAME; otherwise returns null
get_azuread_directory_role_template () {
    DISPLAY_NAME="${1}"

    ENDPOINT='/directoryRoleTemplates'

    URL=$(printf "%s" ${BASE_URL} ${ENDPOINT})

    ROLE_TEMPLATE_ID=$(az rest --method get --url ${URL} | \
                        jq -r ".value | map(select(.displayName == \"${DISPLAY_NAME}\")) | .[0].id")
    
    printf ${ROLE_TEMPLATE_ID}
}

# Activates the role template for the given role tempalte ID
enable_azuread_directory_role () {
    ROLE_TEMPLATE_ID=${1}

    ENDPOINT_URL=$(endpoint_directory_roles)
    ENDPOINT_BODY=$(activate_directory_role_body ${ROLE_TEMPLATE_ID})

    az rest --method post \
        --url ${ENDPOINT_URL} \
        --body "${ENDPOINT_BODY}"
}

# Create a new directory role member
add_azuread_directory_role_member () {
    ROLE_ID=${1}
    PRINCIPAL_ID=${2}

    ENDPOINT_URL=$(endpoint_directory_roles)
    ROLE_MEMBERS_URL=$(printf "%s" ${ENDPOINT_URL} '/' ${ROLE_ID} '/members/$ref')
    ENDPOINT_BODY=$(add_directory_role_member_body ${PRINCIPAL_ID})

    az rest --method post \
        --url ${ROLE_MEMBERS_URL} \
        --body "${ENDPOINT_BODY}"
}

# Search directory role for a member
check_principal_directory_role () {
    PRINCIPAL_ID=${1}
    ROLE_ID=${2}

    ENDPOINT_URL=$(printf "%s" ${BASE_URL} '/servicePrincipals/' ${PRINCIPAL_ID} '/memberOf/microsoft.graph.directoryRole')
    SELECT='$select=id'
    URL=$(printf "%s" ${ENDPOINT_URL} '?' ${SELECT})
    ROLE_COUNT=$(az rest --method get \
                    --url ${URL} | \
                    jq -r ".value | map(select(.id == \"${ROLE_ID}\")) | length")

    printf ${ROLE_COUNT}
}

PRINCIPAL_ID='7df3519c-b805-4334-a9b5-a6b7fa781074'

ROLE_NAMES=('Directory Readers' 'Groups Administrator')
for ROLE_NAME in "${ROLE_NAMES[@]}"
do
    # BEGIN ENSURE ROLE
    ROLE_ID=$(get_azuread_directory_role "${ROLE_NAME}")
    if [ -z "${ROLE_ID}" ]
    then
        ROLE_TEMPLATE_ID=$(get_azuread_directory_role_template "${ROLE_NAME}")
        enable_azuread_directory_role ${ROLE_TEMPLATE_ID}
        ROLE_ID=$(get_azuread_directory_role "${ROLE_NAME}")
    fi
    # END ENSURE ROLE

    # BEGIN ENSURE ROLE MEMBERSHIP
    ROLE_COUNT=$(check_principal_directory_role ${PRINCIPAL_ID} ${ROLE_ID})
    if [ 0 == "${ROLE_COUNT}" ]
    then
        add_azuread_directory_role_member ${ROLE_ID} ${PRINCIPAL_ID}
        echo "Added principal to role: ${ROLE_NAME}"
    else
        echo "Principal has existing membership for role: ${ROLE_NAME}"
    fi
    # END ENSURE MEMBERSHIP
done