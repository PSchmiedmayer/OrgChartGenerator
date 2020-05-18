//
//  File.swift
//  
//
//  Created by Paul Schmiedmayer on 11/4/19.
//

import Leaf

#warning("Replace the enum with the .leaf resources once SPM supports resouces: https://bugs.swift.org/browse/SR-2866")
/// LeafTemplate
/// Needed to be able to distribute the OrgChart Generator as a binary as resources are currently not bundled in binaries build using the SPM.
class LeafTemplate: LeafFiles {
    let html: String = #"""
    <!DOCTYPE html>
    <meta charset="utf-8">
    <title>#(title)</title>
    <head>
    <style>
    * {
        margin: 0;
        padding: 0;
        word-wrap: break-word;
    }

    body {
        position: relative;
        display: inline-block;
        font-family: "Helvetica Neue", "Helvetica";
        font-size: 13pt;
    }

    thead td {
        vertical-align: top;
        padding-bottom: 40px;
    }

    header {
        display: flex;
        align-items: center;
    }

    h1 {
        text-align: center;
        font-size: 64pt;
        font-weight: 400;
        flex-grow: 1;
    }

    h2 {
        text-align: center;
        margin-top: 20px;
        font-size: 15pt;
        font-weight: 500;
    }

    h3 {
        text-align: center;
        font-size: 14pt;
        font-weight: 500;
    }

    img, span.face {
        height: 60px;
    }

    span.face img {
        width: 60px;
    }

    table {
        border-spacing: 20px 0;
        margin: 20px 0;
    }

    tbody td {
        position: relative;
        padding: 10px 5px;
        padding-left: 8px;
        vertical-align: top;
        font-weight: 500;
    }

    tbody td::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        z-index: -2;
    }

    p {
        display: inline-block;
        vertical-align: middle;
        min-width: 250px;
        height: 60px;
        padding: 10px 5px;
    }

    p::before {
        content: '';
        display: inline-block;
        height: 100%;
        vertical-align: middle;
    }

    p > span.caption {
        display: inline-block;
        vertical-align: middle;
        margin-left: 70px;
        font-weight: 300;
        width: calc(100% - 90px)
    }

    span.name {
        font-weight: 500
    }

    p > span.face {
        position: absolute;
        padding: 2px;
    }

    p > span.face::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: calc(100% - 4px);
        height: calc(100% - 4px);
        z-index: -2;
        border: rgba(0, 0, 0, .3) solid 2px;
    }

    tr.logo img {
        height: initial;
        max-height: 60px;
        max-width: calc(100% - 10px);
        object-fit: contain;
        margin: 0 auto;
    }

    tr.logo td {
        padding: 0 !important;
        padding-top: 20px !important;
        padding-bottom: 10px !important;
        padding-left: 40px !important;
        padding-right: 40px !important;
        vertical-align: middle;
        text-align: center;
    }

    tr.logo td::before {
        background: none !important;
        border-top-width: 2px !important;
    }

    .box {
        position: relative;
        padding: 5px 12px;
        border-width: 1px 3px;
    }

    #if(topLeft):
        .topLeft {
            background: #(topLeft.background)19;
            border: solid #(topLeft.background)7F;
        \}
    #endif

    #if(topRight):
        .topRight {
            background: #(topRight.background)19;
            border: solid #(topRight.background)7F;
        \}
    #endif

    .box p {
        width: 270px;
    }

    td.overlay {
        min-width: 100px;
        position: initial;
        vertical-align: top;
    }

    td.overlay::before {
        content: none;
    }

    td.overlay > * {
        position: absolute !important;
        left: 0;
        right: 0;
        height: 60px;
        margin: 0 20px;
        padding: 11px;
        z-index: -1;
        text-align: right;
    }

    td.overlay > *::before {
        content: '';
        display: inline-block;
        height: 100%;
        vertical-align: middle;
    }

    td.overlay > * > * {
        display: inline-block;
        vertical-align: middle;
        text-align: right;
    }

    #for(teamStyle in teamStyles):
        tbody td:nth-child(#(index + 1)) {
            padding: 10px;
            padding-left: 13px;
            min-width: 250px;
        \}

        tbody td:nth-child(#(index + 1)) p {
            padding: 10px;
            width: calc(100% - 20px);
        \}

        tbody td:nth-child(#(index + 1)) p > span.face::before {
            border: 2px solid #(teamStyle.background)4B;
        \}

        tbody td:nth-child(#(index + 1))::before {
            background: #(teamStyle.background)1E;
            border: 0 solid #(teamStyle.background)FF;
            border-left-width: 3px;
            width: calc(100% - 3px);
        \}
    #endfor


    </style>
    </head>
    <body>
        <table>
            <thead>
                <tr>
                    <td colspan="100">
                        <header>
                            #if(topLeft):
                                <div class="box topLeft">
                                    <h3>#(topLeft.title)</h3>
                                    #for(member in topLeft.members):
                                        <p>
                                            <span class="face">
                                                <img src="#(member.picture)">
                                            </span>
                                            <span class="caption">
                                                <span class="name">#(member.name)</span>
                                                <br>
                                                #(member.role)
                                            </span>
                                        </p>
                                    #endfor
                                </div>
                            #endif
                            <h1>#(title)</h1>
                            #if(topRight):
                                <div class="box topRight">
                                    <h3>#(topRight.title)</h3>
                                    #for(member in topRight.members):
                                        <p>
                                            <span class="face">
                                                <img src="#(member.picture)">
                                            </span>
                                            <span class="caption">
                                                <span class="name">#(member.name)</span>
                                                <br>
                                                #(member.role)
                                            </span>
                                        </p>
                                    #endfor
                                </div>
                            #endif
                        </header>
                    </td>
                </tr>
            </thead>
            <tbody>
                <tr class="logo">
                    #for(teamStyle in teamStyles):
                        <td>
                            <img src="#(teamStyle.logo)" style="height: 100px;">
                        </td>
                    #endfor
                </tr>
                #for(row in rows):
                    #if(row.heading):
                        <tr>
                            #for(teamMembers in row.teamMembers):
                                <td>
                                    <h2>#(row.heading)</h2>
                                </td>
                            #endfor
                        </tr>
                    #endif
                    <tr>
                        #for(teamMembers in row.teamMembers):
                            <td>
                                #for(teamMember in teamMembers):
                                    <p>
                                        <span class="face">
                                            <img src="#(teamMember.picture)">
                                        </span>
                                        <span class="caption">
                                            <span class="name">
                                                #(teamMember.name)
                                            </span>
                                            <br>
                                            #(teamMember.role)
                                        </span>
                                    </p>
                                #endfor
                            </td>
                        #endfor
                        #if(row.management):
                            #for(member in row.management.members):
                                <td>
                                    <p>
                                        <span class="face">
                                            <img src="#(member.picture)">
                                        </span>
                                        <span class="caption">
                                            <span class="name">
                                                #(member.name)
                                            </span>
                                            <br>
                                            #(member.role)
                                        </span>
                                    </p>
                                </td>
                            #endfor
                            <td class="overlay">
                                #if(row.background && row.background != "#FFFFFF"):
                                    <span class="box" style="background: #(row.background)19; border: solid #(row.background)7F;">
                                #else:
                                    <span class="box">
                                #endif
                                    <h3>#(row.management.title)</h3>
                                </span>
                            </td>
                        #endif
                    </tr>
                #endfor
            </tbody>
        </table>
    </body>
    """#
    
    
    func file(path: String, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        var buffer = ByteBufferAllocator().buffer(capacity: 0)
        buffer.writeString(html)
        return eventLoop.makeSucceededFuture(buffer)
    }
}