*** Settings ***
Library           SeleniumLibrary
Documentation     Test cases for website login functionality

*** Variables ***
${URL}            # Replace with actual test URL
${BROWSER}        chrome
${USERNAME}       your_username    # Replace with actual test username
${PASSWORD}       your_password    # Replace with actual test password
${LOGIN_LINK}     xpath://a[contains(text(),'Login ')]
${USERNAME_FIELD}    name:username    # Update if actual name attribute is different
${PASSWORD_FIELD}    name:password    # Update if actual name attribute is different
${LOGIN_BTN}      xpath://button[contains(text(),'Login')]    # Update with actual login button text
${ERROR_MSG}      css:.error-message    # Update with actual error message locator
${LOGOUT_BTN}     xpath://a[contains(text(),'Logout')]    # Update with actual logout text
${POPUP_CLOSE_BTN}    xpath://button[contains(@class,'close')] | //a[contains(@class,'close')]    # Update with actual close button
${POPUP_IFRAME}    css:.popup-iframe    # Update if popup is in iframe

*** Keywords ***
Open The Best Website
    [Arguments]    ${url}    ${browser}
    Open Browser    ${url}    ${browser}
    Maximize Browser Window

Close The Browser
    Close Browser

Handle Popup If Present
    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${POPUP_CLOSE_BTN}
    Run Keyword If    ${status}    Close Popup

Close Popup
    # ถ้า popup อยู่ใน iframe
    ${iframe_present}=    Run Keyword And Return Status    Element Should Be Visible    ${POPUP_IFRAME}
    Run Keyword If    ${iframe_present}    Select Frame    ${POPUP_IFRAME}
    Wait Until Element Is Visible    ${POPUP_CLOSE_BTN}    timeout=5s
    Click Element    ${POPUP_CLOSE_BTN}
    Run Keyword If    ${iframe_present}    Unselect Frame
    Sleep    1s    # รอให้ popup หายไป

Click Login Link
    Handle Popup If Present
    Wait Until Element Is Visible    ${LOGIN_LINK}
    Click Element    ${LOGIN_LINK}

Input Login Credentials
    [Arguments]    ${username}    ${password}
    Handle Popup If Present
    Wait Until Element Is Visible    ${USERNAME_FIELD}
    Input Text    ${USERNAME_FIELD}    ${username}
    Input Password    ${PASSWORD_FIELD}    ${password}

Click Login Button
    Handle Popup If Present
    Wait Until Element Is Enabled    ${LOGIN_BTN}
    Click Element    ${LOGIN_BTN}

Verify Successful Login
    Handle Popup If Present
    Wait Until Element Is Visible    ${LOGOUT_BTN}
    Element Should Be Visible    ${LOGOUT_BTN}

Verify Failed Login
    Handle Popup If Present
    Wait Until Element Is Visible    ${ERROR_MSG}
    Element Should Be Visible    ${ERROR_MSG}

Logout
    Handle Popup If Present
    Wait Until Element Is Enabled    ${LOGOUT_BTN}
    Click Element    ${LOGOUT_BTN}

*** Test Cases ***
TS_01 : Open Website and Close Browser
    Open The Best Website    ${URL}    ${BROWSER}
    Handle Popup If Present
    Close The Browser

TS_02 : Valid Login
    [Documentation]    Test login with valid credentials
    Open The Best Website    ${URL}    ${BROWSER}
    Click Login Link
    Input Login Credentials    ${USERNAME}    ${PASSWORD}
    Click Login Button
    Verify Successful Login
    Logout
    Close The Browser

TS_03 : Invalid Username Login
    [Documentation]    Test login with invalid username
    Open The Best Website    ${URL}    ${BROWSER}
    Click Login Link
    Input Login Credentials    invalid_username    ${PASSWORD}
    Click Login Button
    Verify Failed Login
    Close The Browser

TS_04 : Invalid Password Login
    [Documentation]    Test login with invalid password
    Open The Best Website    ${URL}    ${BROWSER}
    Click Login Link
    Input Login Credentials    ${USERNAME}    invalid_password
    Click Login Button
    Verify Failed Login
    Close The Browser

TS_05 : Empty Credentials Login
    [Documentation]    Test login with empty credentials
    Open The Best Website    ${URL}    ${BROWSER}
    Click Login Link
    Input Login Credentials    ${EMPTY}    ${EMPTY}
    Click Login Button
    Verify Failed Login
    Close The Browser