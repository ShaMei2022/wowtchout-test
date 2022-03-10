*** Setting ***
Library    Collections
Library    String
Library    RequestsLibrary
Library    Selenium2Library
Library    Screenshot
Library    OperatingSystem

Suite Setup    Open Browser    https://www.wowtchout.com/map    chrome    executable_path=./chromedriver
Suite Teardown    Close Browser

*** Test Cases ***
Open Website
    [Documentation]    點開網頁
    [Tags]    get
    ${opener}=    GET     https://www.wowtchout.com/map
    Status Should Be    OK    ${opener}

Get Web Content
    [Documentation]    抓取內頁內容
    [Tags]    grast
    ${request body}=    Get File    ./drive.json
    ${head}=    Create Dictionary    Content-Type=application/json
    ${grast}=    POST    https://www.wowtchout.com/api/graphql    data=${request body}    headers=${head}
    Status Should Be    OK     ${grast}
    Log     ${grast.text}

Get Web Title
    [Documentation]     抓取內頁原標題
    [Tags]      grast
    ${request body 2}=    Get File    ./id.json
    ${head2}=    Create Dictionary    Content-Type=application/json
    ${grast2}=    POST    https://www.wowtchout.com/api/graphql   data=${request body2}    headers=${head2}
    Status Should Be    OK    ${grast2}
    Log    ${grast2.text}

Get Title
    [Documentation]    抓取原標題
    [Tags]    grast
    Wait Until Element Is Visible    //*[@id="__next"]/div/div[2]/div/div/div[1]/div/div[3]
    ${title}=    Get WebElements    //*[@id="__next"]/div/div[2]/div/div/div[1]/div/div[3]/div[*]
    FOR    ${T}    IN    @{title}
        ${text}=    GET Text    ${T}
        Log    ${text}
    END

Open Viedo 
    [Documentation]    進入所有影片並關閉
    [Tags]    grast
    Wait Until Element Is Visible    //*[@id="__next"]/div/div[2]/div/div/div[1]/div/div[3]
    ${open}=    Get WebElements    //*[@id="__next"]/div/div[2]/div/div/div[1]/div/div[3]/div[*]/a
    FOR    ${O}    IN    @{open}
        Click Element    ${O}
        sleep    2s
        Press Keys    None    ESC
    Set Focus To Element    //*[@id="__next"]/div/div[2]/div/div/div[1]/div/div[3]/div[10]/a
    END

Get Viedo Information Bar
    [Documentation]    進入所有影片並擷取資訊欄
    [Tags]    grast
    ${open}=    Get WebElements    //*[@id="__next"]/div/div[2]/div/div/div[1]/div/div[3]/div[*]/a
    FOR    ${O}    IN    @{open}
        Click Element    ${O}
        sleep    1s
        ${description}=    Get WebElement    //html/body/div[4]/div/div[2]/div/div[2]/div/div/div[2]/div[1]/div[4]
        ${des}=    GET Text    ${description}
        Log    ${des}
        Press Keys    None    ESC
    Set Focus To Element    //*[@id="__next"]/div/div[2]/div/div/div[1]/div/div[3]/div[10]/a
    END

Compare Two Data
    [Documentation]    比對兩筆資料
    [Tags]    grast
    # 使用requests取得預期資料
    ${request body}=    Get File    ./drive.json
    ${head}=    Create Dictionary    Content-Type=application/json
    ${grast}=    POST    https://www.wowtchout.com/api/graphql    data=${request body}    headers=${head}
    Status Should Be    OK     ${grast}

    # 使用selenium取得全部元素
    ${tit}=    Get WebElements    //*[@id="__next"]/div/div[2]/div/div/div[1]/div/div[3]/div[*]/a/div[2]/h3
    ${titl}=    Get length    ${tit}

    # 比對全部資料
    FOR    ${i}    IN RANGE    ${titl}
        # 拿取資料，同等title[i].text
        ${actual}=    Get Text    ${tit}[${i}]

        # 拿取資料，同等dictinfo["data"]["videos"][i]["title"]
        ${e}=    Get From Dictionary    ${grast.json()}    data
        ${e}=    Get From Dictionary    ${e}    videos
        ${e}=    Get From Dictionary    ${e}    ${i}
        ${e}=    Get From Dictionary    ${e}    title

        # 比對
        Log    ${actual}
        Log    ${e}
        Should Be Equal    ${actual}    ${e}
    END

Compare Title Data
    [Documentation]    拿取內頁標題比對
    [Tags]    grast
    ${vedioElements}=    Get WebElements    //*[@id="__next"]/div/div[2]/div/div/div[1]/div/div[3]/div[*]/a
    ${titleElements}=    Get WebElements    //*[@id="__next"]/div/div[2]/div/div/div[1]/div/div[3]/div[*]/a/div[2]/h3
    ${titleElementsLength}=    Get length    ${titleElements}
    ${requestBody}=    Get File    ./drive.json
    ${requestHead}=    Create Dictionary    Content-Type=application/json
    ${exceptData}=    POST    https://www.wowtchout.com/api/graphql    data=${requestBody}    headers=${requestHead}
    FOR    ${index}    IN RANGE    ${titleElementsLength}
        ${outsideTitleText}=    Get Text    ${titleElements}[${index}]
        Click Element    ${vedioElements}[${index}]
        sleep    0.5s

        ${descriptionElement}=    Get WebElement    //html/body/div[4]/div/div[2]/div/div[2]/div/div/div[2]/div[1]/div[4]
        ${descriptionText}=    GET Text    ${descriptionElement}
        Log    ${descriptionText}

        ${insideTitleElement}=    Get WebElement    //html/body/div[4]/div/div[2]/div/div[2]/div/div/div[2]/div[1]/div[1]/h1
        ${insideTitleText}=    GET Text    ${insideTitleElement}
        Log    ${insideTitleText}

        Should Be Equal    ${exceptData.json()}[data][videos][${index}][title]    ${insideTitleText}
        Should Be Equal    ${exceptData.json()}[data][videos][${index}][title]    ${outsideTitleText}
        Should Be Equal    ${exceptData.json()}[data][videos][${index}][description]    ${descriptionText}

        Press Keys    None    ESC
        Set Focus To Element    //*[@id="__next"]/div/div[2]/div/div/div[1]/div/div[3]/div[10]/a
    END