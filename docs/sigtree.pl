$VAR1 = [
          'Document',
          {
            'start_line' => 3
          },
          [
            'head1',
            {
              'start_line' => 3
            },
            'NAME'
          ],
          [
            'Para',
            {
              'start_line' => 5
            },
            'Irssi Signal Documentation'
          ],
          [
            'head1',
            {
              'start_line' => 7
            },
            'DESCRIPTION'
          ],
          [
            'Para',
            {
              'start_line' => 9
            },
            'Perl POD documentation based on the doc/signals.txt documentation supplied with Irssi.'
          ],
          [
            'head1',
            {
              'start_line' => 12
            },
            'USING SIGNALS'
          ],
          [
            'Para',
            {
              'start_line' => 14
            },
            'See ',
            [
              'L',
              {
                'to' => bless( [
                                 '',
                                 {},
                                 'Irssi'
                               ], 'Pod::Simple::LinkSection' ),
                'section' => bless( [
                                      '',
                                      {},
                                      'Signals'
                                    ], 'Pod::Simple::LinkSection' ),
                'type' => 'pod',
                'content-implicit' => 'yes'
              },
              '"',
              'Signals',
              '" in ',
              'Irssi'
            ]
          ],
          [
            'for',
            {
              '~really' => '=begin',
              'target' => 'irssi_signal_types',
              '~ignore' => 0,
              'target_matching' => 'irssi_signal_types',
              'start_line' => 97,
              '~resolve' => 0
            },
            [
              'Data',
              {
                'xml:space' => 'preserve',
                'start_line' => 18
              },
              'START OF SIGNAL TYPES'
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 20
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 22
                },
                [
                  'C',
                  {},
                  'GList \\* of ([^,]*)'
                ],
                ' ',
                [
                  'C',
                  {},
                  'glistptr_$1'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 24
                },
                [
                  'C',
                  {},
                  'GSList \\* of (\\w+)s'
                ],
                ' ',
                [
                  'C',
                  {},
                  'gslist_$1'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 26
                },
                [
                  'C',
                  {},
                  'char \\*'
                ],
                ' ',
                [
                  'C',
                  {},
                  'string'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 28
                },
                [
                  'C',
                  {},
                  'ulong \\*'
                ],
                ' ',
                [
                  'C',
                  {},
                  'ulongptr'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 30
                },
                [
                  'C',
                  {},
                  'int \\*'
                ],
                ' ',
                [
                  'C',
                  {},
                  'intptr'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 32
                },
                [
                  'C',
                  {},
                  'int'
                ],
                ' ',
                [
                  'C',
                  {},
                  'int'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 36
                },
                [
                  'C',
                  {},
                  'CHATNET_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'iobject'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 38
                },
                [
                  'C',
                  {},
                  'SERVER_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'iobject'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 40
                },
                [
                  'C',
                  {},
                  'RECONNECT_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'iobject'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 42
                },
                [
                  'C',
                  {},
                  'CHANNEL_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'iobject'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 44
                },
                [
                  'C',
                  {},
                  'QUERY_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'iobject'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 46
                },
                [
                  'C',
                  {},
                  'COMMAND_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'iobject'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 48
                },
                [
                  'C',
                  {},
                  'NICK_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'iobject'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 50
                },
                [
                  'C',
                  {},
                  'LOG_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'Irssi::Log'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 52
                },
                [
                  'C',
                  {},
                  'RAWLOG_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'Irssi::Rawlog'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 54
                },
                [
                  'C',
                  {},
                  'IGNORE_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'Irssi::Ignore'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 56
                },
                [
                  'C',
                  {},
                  'MODULE_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'Irssi::Module'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 59
                },
                [
                  'C',
                  {},
                  'BAN_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'Irssi::Irc::Ban'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 61
                },
                [
                  'C',
                  {},
                  'NETSPLIT_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'Irssi::Irc::Netsplit'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 63
                },
                [
                  'C',
                  {},
                  'NETSPLIT_SERVER__REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'Irssi::Irc::Netsplitserver'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 66
                },
                [
                  'C',
                  {},
                  'DCC_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'siobject'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 68
                },
                [
                  'C',
                  {},
                  'AUTOIGNORE_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'Irssi::Irc::Autoignore'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 70
                },
                [
                  'C',
                  {},
                  'AUTOIGNORE_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'Irssi::Irc::Autoignore'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 72
                },
                [
                  'C',
                  {},
                  'NOTIFYLIST_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'Irssi::Irc::Notifylist'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 74
                },
                [
                  'C',
                  {},
                  'CLIENT_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'Irssi::Irc::Client'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 77
                },
                [
                  'C',
                  {},
                  'THEME_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'Irssi::UI::Theme'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 79
                },
                [
                  'C',
                  {},
                  'KEYINFO_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'Irssi::UI::Keyinfo'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 81
                },
                [
                  'C',
                  {},
                  'PROCESS_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'Irssi::UI::Process'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 83
                },
                [
                  'C',
                  {},
                  'TEXT_DEST_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'Irssi::UI::TextDest'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 85
                },
                [
                  'C',
                  {},
                  'WINDOW_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'Irssi::UI::Window'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 87
                },
                [
                  'C',
                  {},
                  'WI_ITEM_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'iobject'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 91
                },
                [
                  'C',
                  {},
                  'PERL_SCRIPT_REC'
                ],
                ' ',
                [
                  'C',
                  {},
                  'Irssi::Script'
                ]
              ]
            ],
            [
              'Data',
              {
                'xml:space' => 'preserve',
                'start_line' => 95
              },
              'END OF SIGNAL TYPES'
            ]
          ],
          [
            'head1',
            {
              'start_line' => 99
            },
            'SIGNAL DEFINITIONS'
          ],
          [
            'Para',
            {
              'start_line' => 101
            },
            'The following signals are categorised as in the original documentation, but have been revised to note Perl variable types and class names.'
          ],
          [
            'Para',
            {
              'start_line' => 104
            },
            'Arguments are passed to signal handlers in the usual way, via ',
            [
              'C',
              {},
              '@_'
            ],
            '.'
          ],
          [
            'for',
            {
              'target' => 'irssi_signal_defs',
              '~really' => '=for',
              '~ignore' => 0,
              'target_matching' => 'irssi_signal_defs',
              'start_line' => 106,
              '~resolve' => 0
            },
            [
              'Data',
              {
                'xml:space' => 'preserve',
                'start_line' => 106
              },
              'START OF SIGNAL DEFINITIONS'
            ]
          ],
          [
            'head2',
            {
              'start_line' => 108
            },
            'Core'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 110
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 112
              },
              [
                'C',
                {},
                '"gui exit"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 114
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 116
                },
                [
                  'I',
                  {},
                  'None'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 120
              },
              [
                'C',
                {},
                '"gui dialog"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 122
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 124
                },
                'string ',
                [
                  'C',
                  {},
                  '$type'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 126
                },
                'string ',
                [
                  'C',
                  {},
                  '$text'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 130
              },
              [
                'C',
                {},
                '"send command"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 132
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 134
                },
                [
                  'C',
                  {},
                  'string $command'
                ],
                ','
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 136
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ],
                ','
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 138
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Windowitem'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Windowitem'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window_item'
                ]
              ]
            ],
            [
              'Para',
              {
                'start_line' => 142
              },
              'This is sent when a command is entered via the GUI, or by scripts via ',
              [
                'L',
                {
                  'to' => bless( [
                                   '',
                                   {},
                                   'Irssi::command'
                                 ], 'Pod::Simple::LinkSection' ),
                  'type' => 'pod',
                  'content-implicit' => 'yes'
                },
                'Irssi::command'
              ],
              '.'
            ]
          ],
          [
            'head3',
            {
              'start_line' => 146
            },
            [
              'F',
              {},
              'chat-protocols.c'
            ],
            ':'
          ],
          [
            'Para',
            {
              'start_line' => 148
            },
            [
              'B',
              {},
              'TODO: What are CHAT_PROTOCOL_REC types?'
            ]
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 150
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 152
              },
              [
                'C',
                {},
                '"chat protocol created"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 154
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 156
                },
                'CHAT_PROTOCOL_REC ',
                [
                  'C',
                  {},
                  '$protocol'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 160
              },
              [
                'C',
                {},
                '"chat protocol updated"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 162
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 164
                },
                'CHAT_PROTOCOL_REC ',
                [
                  'C',
                  {},
                  '$protocol'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 168
              },
              [
                'C',
                {},
                '"chat protocol destroyed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 170
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 172
                },
                'CHAT_PROTOCOL_REC ',
                [
                  'C',
                  {},
                  '$protocol'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 178
            },
            [
              'F',
              {},
              'channels.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 180
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 182
              },
              [
                'C',
                {},
                '"channel created"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 184
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 186
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Channel'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Channel'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 188
                },
                'int ',
                [
                  'C',
                  {},
                  '$automatic'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 192
              },
              [
                'C',
                {},
                '"channel destroyed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 194
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 196
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Channel'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Channel'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 202
            },
            [
              'F',
              {},
              'chatnets.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 204
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 206
              },
              [
                'C',
                {},
                '"chatnet created"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 208
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 210
                },
                'CHATNET_REC ',
                [
                  'C',
                  {},
                  '$chatnet'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 214
              },
              [
                'C',
                {},
                '"chatnet destroyed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 216
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 218
                },
                'CHATNET_REC ',
                [
                  'C',
                  {},
                  '$chatnet'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 224
            },
            [
              'F',
              {},
              'commands.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 226
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 228
              },
              [
                'C',
                {},
                '"commandlist new"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 230
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 232
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Command'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Command'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$cmd'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 236
              },
              [
                'C',
                {},
                '"commandlist remove"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 238
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 240
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Command'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Command'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$cmd'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 244
              },
              [
                'C',
                {},
                '"error command"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 246
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 248
                },
                'int ',
                [
                  'C',
                  {},
                  '$err'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 250
                },
                'string ',
                [
                  'C',
                  {},
                  '$cmd'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 254
              },
              [
                'C',
                {},
                '"send command"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 256
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 258
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 260
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 262
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Windowitem'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Windowitem'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$witem'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 266
              },
              [
                'C',
                {},
                '"send text"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 268
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 270
                },
                'string ',
                [
                  'C',
                  {},
                  '$line'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 272
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 274
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Windowitem'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Windowitem'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$witem'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 278
              },
              [
                'C',
                {},
                '"command "<cmd'
              ],
              '>'
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 280
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 282
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 284
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 286
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Windowitem'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Windowitem'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$witem'
                ]
              ]
            ],
            [
              'Para',
              {
                'start_line' => 290
              },
              [
                'B',
                {},
                'TODO: check this "cmd" out?'
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 292
              },
              [
                'C',
                {},
                '"default command"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 294
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 296
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 298
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 300
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Windowitem'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Windowitem'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$witem'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 306
            },
            [
              'F',
              {},
              'ignore.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 308
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 310
              },
              [
                'C',
                {},
                '"ignore created"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 312
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 314
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Ignore'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Ignore'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$ignore'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 318
              },
              [
                'C',
                {},
                '"ignore destroyed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 320
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 322
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Ignore'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Ignore'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$ignore'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 326
              },
              [
                'C',
                {},
                '"ignore changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 328
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 330
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Ignore'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Ignore'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$ignore'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 336
            },
            [
              'F',
              {},
              'log.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 338
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 340
              },
              [
                'C',
                {},
                '"log new"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 342
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 344
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Log'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Log'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$log'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 348
              },
              [
                'C',
                {},
                '"log remove"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 350
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 352
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Log'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Log'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$log'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 356
              },
              [
                'C',
                {},
                '"log create failed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 358
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 360
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Log'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Log'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$log'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 364
              },
              [
                'C',
                {},
                '"log locked"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 366
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 368
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Log'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Log'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$log'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 372
              },
              [
                'C',
                {},
                '"log started"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 374
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 376
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Log'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Log'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$log'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 380
              },
              [
                'C',
                {},
                '"log stopped"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 382
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 384
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Log'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Log'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$log'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 388
              },
              [
                'C',
                {},
                '"log rotated"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 390
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 392
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Log'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Log'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$log'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 396
              },
              [
                'C',
                {},
                '"log written"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 398
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 400
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Log'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Log'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$log'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 402
                },
                'string ',
                [
                  'C',
                  {},
                  '$line'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 408
            },
            [
              'F',
              {},
              'modules.c'
            ],
            ':'
          ],
          [
            'Para',
            {
              'start_line' => 410
            },
            [
              'B',
              {},
              'TODO: what are these types?'
            ]
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 412
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 414
              },
              [
                'C',
                {},
                '"module loaded"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 416
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 418
                },
                'MODULE_REC ',
                [
                  'C',
                  {},
                  '$module'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 420
                },
                'MODULE_FILE_REC ',
                [
                  'C',
                  {},
                  '$module_file'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 424
              },
              [
                'C',
                {},
                '"module unloaded"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 426
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 428
                },
                'MODULE_REC ',
                [
                  'C',
                  {},
                  '$module'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 430
                },
                'MODULE_FILE_REC ',
                [
                  'C',
                  {},
                  '$module_file'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 434
              },
              [
                'C',
                {},
                '"module error"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 436
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 438
                },
                'int ',
                [
                  'C',
                  {},
                  '$error'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 440
                },
                'string ',
                [
                  'C',
                  {},
                  '$text'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 442
                },
                'string ',
                [
                  'C',
                  {},
                  '$root_module'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 444
                },
                'string ',
                [
                  'C',
                  {},
                  '$sub_module'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 450
            },
            [
              'F',
              {},
              'nicklist.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 452
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 454
              },
              [
                'C',
                {},
                '"nicklist new"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 456
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 458
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Channel'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Channel'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 460
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Nick'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Nick'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 464
              },
              [
                'C',
                {},
                '"nicklist remove"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 466
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 468
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Channel'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Channel'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 470
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Nick'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Nick'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 474
              },
              [
                'C',
                {},
                '"nicklist changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 476
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 478
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Channel'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Channel'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 480
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Nick'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Nick'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 482
                },
                'string ',
                [
                  'C',
                  {},
                  '$old_nick'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 486
              },
              [
                'C',
                {},
                '"nicklist host changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 488
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 490
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Channel'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Channel'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 492
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Nick'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Nick'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 496
              },
              [
                'C',
                {},
                '"nicklist gone changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 498
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 500
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Channel'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Channel'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 502
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Nick'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Nick'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 506
              },
              [
                'C',
                {},
                '"nicklist serverop changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 508
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 510
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Channel'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Channel'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 512
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Nick'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Nick'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 518
            },
            [
              'F',
              {},
              'pidwait.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 520
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 522
              },
              [
                'C',
                {},
                '"pidwait"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 524
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 526
                },
                'int ',
                [
                  'C',
                  {},
                  '$pid'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 528
                },
                'int ',
                [
                  'C',
                  {},
                  '$status'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 534
            },
            [
              'F',
              {},
              'queries.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 536
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 538
              },
              [
                'C',
                {},
                '"query created"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 540
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 542
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Query'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Query'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$query'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 544
                },
                'int ',
                [
                  'C',
                  {},
                  '$automatic'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 548
              },
              [
                'C',
                {},
                '"query destroyed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 550
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 552
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Query'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Query'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$query'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 556
              },
              [
                'C',
                {},
                '"query nick changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 558
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 560
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Query'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Query'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$query'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 562
                },
                'string ',
                [
                  'C',
                  {},
                  '$original_nick'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 566
              },
              [
                'C',
                {},
                '"window item name changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 568
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 570
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Windowitem'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Windowitem'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$witem'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 574
              },
              [
                'C',
                {},
                '"query address changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 576
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 578
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Query'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Query'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$query'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 582
              },
              [
                'C',
                {},
                '"query server changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 584
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 586
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Query'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Query'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$query'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 588
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 595
            },
            [
              'F',
              {},
              'rawlog.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 597
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 599
              },
              [
                'C',
                {},
                '"rawlog"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 601
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 603
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Rawlog'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Rawlog'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$raw_log'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 605
                },
                'string ',
                [
                  'C',
                  {},
                  '$data'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 611
            },
            [
              'F',
              {},
              'server.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 613
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 615
              },
              [
                'C',
                {},
                '"server looking"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 617
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 619
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 623
              },
              [
                'C',
                {},
                '"server connected"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 625
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 627
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 632
              },
              [
                'C',
                {},
                '"server connecting"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 634
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 636
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 638
                },
                'ulongptr ',
                [
                  'C',
                  {},
                  '$ip'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 642
              },
              [
                'C',
                {},
                '"server connect failed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 644
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 646
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 650
              },
              [
                'C',
                {},
                '"server disconnected"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 652
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 654
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 658
              },
              [
                'C',
                {},
                '"server quit"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 660
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 662
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 664
                },
                'string ',
                [
                  'C',
                  {},
                  '$message'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 668
              },
              [
                'C',
                {},
                '"server sendmsg"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 670
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 672
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 674
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 676
                },
                'string ',
                [
                  'C',
                  {},
                  '$message'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 678
                },
                'int ',
                [
                  'C',
                  {},
                  '$target_type'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 684
            },
            [
              'F',
              {},
              'settings.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 686
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 688
              },
              [
                'C',
                {},
                '"setup changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 690
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 692
                },
                [
                  'I',
                  {},
                  'None'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 696
              },
              [
                'C',
                {},
                '"setup reread"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 698
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 700
                },
                'string ',
                [
                  'C',
                  {},
                  '$fname'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 704
              },
              [
                'C',
                {},
                '"setup saved"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 706
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 708
                },
                'string ',
                [
                  'C',
                  {},
                  '$fname'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 710
                },
                'int ',
                [
                  'C',
                  {},
                  '$autosaved'
                ]
              ]
            ]
          ],
          [
            'head2',
            {
              'start_line' => 716
            },
            'IRC Core'
          ],
          [
            'head3',
            {
              'start_line' => 718
            },
            [
              'F',
              {},
              'bans.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 720
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 722
              },
              [
                'C',
                {},
                '"ban type changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 724
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 726
                },
                'string ',
                [
                  'C',
                  {},
                  '$bantype'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 732
            },
            [
              'F',
              {},
              'channels'
            ],
            ', ',
            [
              'F',
              {},
              'nicklist'
            ],
            ':'
          ],
          [
            'Para',
            {
              'start_line' => 734
            },
            [
              'B',
              {},
              'TODO: are these actual files? .c?'
            ]
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 736
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 738
              },
              [
                'C',
                {},
                '"channel joined"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 740
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 742
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Channel'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Channel'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 746
              },
              [
                'C',
                {},
                '"channel wholist"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 748
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 750
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Channel'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Channel'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 754
              },
              [
                'C',
                {},
                '"channel sync"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 756
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 758
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Channel'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Channel'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 762
              },
              [
                'C',
                {},
                '"channel topic changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 764
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 766
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Channel'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Channel'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 772
            },
            [
              'F',
              {},
              'ctcp.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 774
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 776
              },
              [
                'C',
                {},
                '"ctcp msg"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 778
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 780
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 782
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 784
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 786
                },
                'string ',
                [
                  'C',
                  {},
                  '$addr'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 788
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 792
              },
              [
                'C',
                {},
                '"ctcp msg "<cmd'
              ],
              '>'
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 794
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 796
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 798
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 800
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 802
                },
                'string ',
                [
                  'C',
                  {},
                  '$addr'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 804
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 808
              },
              [
                'C',
                {},
                '"default ctcp msg"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 810
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 812
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 814
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 816
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 818
                },
                'string ',
                [
                  'C',
                  {},
                  '$addr'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 820
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 824
              },
              [
                'C',
                {},
                '"ctcp reply"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 826
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 828
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 830
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 832
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 834
                },
                'string ',
                [
                  'C',
                  {},
                  '$addr'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 836
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 840
              },
              [
                'C',
                {},
                '"ctcp reply "<cmd'
              ],
              '>'
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 842
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 844
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 846
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 848
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 850
                },
                'string ',
                [
                  'C',
                  {},
                  '$addr'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 852
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 856
              },
              [
                'C',
                {},
                '"default ctcp reply"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 858
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 860
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 862
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 864
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 866
                },
                'string ',
                [
                  'C',
                  {},
                  '$addr'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 868
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 872
              },
              [
                'C',
                {},
                '"ctcp action"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 874
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 876
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 878
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 880
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 882
                },
                'string ',
                [
                  'C',
                  {},
                  '$addr'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 884
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 890
            },
            [
              'F',
              {},
              'irc-log.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 892
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 894
              },
              [
                'C',
                {},
                '"awaylog show"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 896
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 898
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Log'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Log'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$log'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 900
                },
                'int ',
                [
                  'C',
                  {},
                  '$away_msgs'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 902
                },
                'int ',
                [
                  'C',
                  {},
                  '$filepos'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 908
            },
            [
              'F',
              {},
              'irc-nicklist.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 910
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 912
              },
              [
                'C',
                {},
                '"server nick changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 914
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 916
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 922
            },
            [
              'F',
              {},
              'irc-servers.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 924
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 926
              },
              [
                'C',
                {},
                '"event connected"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 928
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 930
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 936
            },
            [
              'F',
              {},
              'irc.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 938
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 940
              },
              [
                'C',
                {},
                '"server event"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 942
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 944
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 946
                },
                'string ',
                [
                  'C',
                  {},
                  '$data'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 948
                },
                'string ',
                [
                  'C',
                  {},
                  '$sender_nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 950
                },
                'string ',
                [
                  'C',
                  {},
                  '$sender_addr'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 954
              },
              [
                'C',
                {},
                '"event "<cmd'
              ],
              '>'
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 956
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 958
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 960
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 962
                },
                'string ',
                [
                  'C',
                  {},
                  '$sender_nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 964
                },
                'string ',
                [
                  'C',
                  {},
                  '$sender_addr'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 968
              },
              [
                'C',
                {},
                '"default event"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 970
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 972
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 974
                },
                'string ',
                [
                  'C',
                  {},
                  '$data'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 976
                },
                'string ',
                [
                  'C',
                  {},
                  '$sender_nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 978
                },
                'string ',
                [
                  'C',
                  {},
                  '$sender_addr'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 982
              },
              [
                'C',
                {},
                '"whois default event"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 984
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 986
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 988
                },
                'string ',
                [
                  'C',
                  {},
                  '$data'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 990
                },
                'string ',
                [
                  'C',
                  {},
                  '$sender_nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 992
                },
                'string ',
                [
                  'C',
                  {},
                  '$sender_addr'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 996
              },
              [
                'C',
                {},
                '"server incoming"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 998
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1000
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1002
                },
                'string ',
                [
                  'C',
                  {},
                  '$data'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1006
              },
              [
                'C',
                {},
                '"redir "<cmd'
              ],
              '>'
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1008
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1010
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1012
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1014
                },
                'string ',
                [
                  'C',
                  {},
                  '$sender_nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1016
                },
                'string ',
                [
                  'C',
                  {},
                  '$sender_addr'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 1022
            },
            [
              'F',
              {},
              'lag.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1024
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1026
              },
              [
                'C',
                {},
                '"server lag"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1028
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1030
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1034
              },
              [
                'C',
                {},
                '"server lag disconnect"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1036
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1038
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 1044
            },
            [
              'F',
              {},
              'massjoin.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1046
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1048
              },
              [
                'C',
                {},
                '"massjoin"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1050
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1052
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Channel'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Channel'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1054
                },
                'List of ',
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Nick'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Nick'
                ],
                ' ',
                [
                  'C',
                  {},
                  '@nicks'
                ]
              ],
              [
                'Para',
                {
                  'start_line' => 1056
                },
                [
                  'B',
                  {},
                  'TODO: Check this is actually a perl list (array)'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 1062
            },
            [
              'F',
              {},
              'mode-lists.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1064
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1066
              },
              [
                'C',
                {},
                '"ban new"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1068
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1070
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Channel'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Channel'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1072
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Irc::Ban'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Irc::Ban'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$ban'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1076
              },
              [
                'C',
                {},
                '"ban remove"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1078
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1080
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Channel'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Channel'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1082
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Irc::Ban'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Irc::Ban'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$ban'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1084
                },
                'string ',
                [
                  'C',
                  {},
                  '$set_by'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 1090
            },
            [
              'F',
              {},
              'modes.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1092
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1094
              },
              [
                'C',
                {},
                '"channel mode changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1096
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1098
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Channel'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Channel'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1100
                },
                'string ',
                [
                  'C',
                  {},
                  '$set_by'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1104
              },
              [
                'C',
                {},
                '"nick mode changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1106
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1108
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Channel'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Channel'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1110
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Nick'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Nick'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1112
                },
                'string ',
                [
                  'C',
                  {},
                  '$set_by'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1114
                },
                'string ',
                [
                  'C',
                  {},
                  '$mode'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1116
                },
                'string ',
                [
                  'C',
                  {},
                  '$type'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1120
              },
              [
                'C',
                {},
                '"user mode changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1122
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1124
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1126
                },
                'string ',
                [
                  'C',
                  {},
                  '$old_mode'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1130
              },
              [
                'C',
                {},
                '"away mode changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1132
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1134
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 1140
            },
            [
              'F',
              {},
              'netsplit.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1142
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1144
              },
              [
                'C',
                {},
                '"netsplit server new"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1146
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1148
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1150
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Irc::Netsplitserver'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Irc::Netsplitserver'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$netsplit_server'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1154
              },
              [
                'C',
                {},
                '"netsplit server remove"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1156
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1158
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1160
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Irc::Netsplitserver'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Irc::Netsplitserver'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$netsplit_server'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1164
              },
              [
                'C',
                {},
                '"netsplit new"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1166
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1168
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Irc::Netsplit'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Irc::Netsplit'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$netsplit'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1172
              },
              [
                'C',
                {},
                '"netsplit remove"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1174
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1176
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Irc::Netsplit'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Irc::Netsplit'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$netsplit'
                ]
              ]
            ]
          ],
          [
            'head2',
            {
              'start_line' => 1182
            },
            'IRC Modules'
          ],
          [
            'head3',
            {
              'start_line' => 1185
            },
            [
              'F',
              {},
              'dcc*.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1187
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1189
              },
              [
                'C',
                {},
                '"dcc ctcp "<cmd'
              ],
              '>'
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1191
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1193
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1195
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1199
              },
              [
                'C',
                {},
                '"default dcc ctcp"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1201
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1203
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1205
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1209
              },
              [
                'C',
                {},
                '"dcc unknown ctcp"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1211
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1213
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1215
                },
                'string ',
                [
                  'C',
                  {},
                  '$sender'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1217
                },
                'string ',
                [
                  'C',
                  {},
                  '$send_addr'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1221
              },
              [
                'C',
                {},
                '"dcc reply "<cmd'
              ],
              '>'
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1223
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1225
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1227
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1231
              },
              [
                'C',
                {},
                '"default dcc reply"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1233
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1235
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1237
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1241
              },
              [
                'C',
                {},
                '"dcc unknown reply"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1243
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1245
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1247
                },
                'string ',
                [
                  'C',
                  {},
                  '$sender'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1249
                },
                'string ',
                [
                  'C',
                  {},
                  '$send_addr'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1253
              },
              [
                'C',
                {},
                '"dcc chat message"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1255
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1257
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1259
                },
                'string ',
                [
                  'C',
                  {},
                  '$msg'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1263
              },
              [
                'C',
                {},
                '"dcc created"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1265
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1267
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1271
              },
              [
                'C',
                {},
                '"dcc destroyed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1273
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1275
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1279
              },
              [
                'C',
                {},
                '"dcc connected"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1281
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1283
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1287
              },
              [
                'C',
                {},
                '"dcc rejecting"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1289
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1291
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1295
              },
              [
                'C',
                {},
                '"dcc closed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1297
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1299
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1303
              },
              [
                'C',
                {},
                '"dcc request"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1305
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1307
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1309
                },
                'string ',
                [
                  'C',
                  {},
                  '$send_addr'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1313
              },
              [
                'C',
                {},
                '"dcc request send"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1315
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1317
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1321
              },
              [
                'C',
                {},
                '"dcc chat message"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1323
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1325
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1327
                },
                'string ',
                [
                  'C',
                  {},
                  '$msg'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1331
              },
              [
                'C',
                {},
                '"dcc transfer update"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1333
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1335
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1339
              },
              [
                'C',
                {},
                '"dcc get receive"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1341
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1343
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1347
              },
              [
                'C',
                {},
                '"dcc error connect"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1349
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1351
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1355
              },
              [
                'C',
                {},
                '"dcc error file create"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1357
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1359
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1361
                },
                'string ',
                [
                  'C',
                  {},
                  '$filename'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1365
              },
              [
                'C',
                {},
                '"dcc error file open"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1367
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1369
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1371
                },
                'string ',
                [
                  'C',
                  {},
                  '$filename'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1373
                },
                'int ',
                [
                  'C',
                  {},
                  '$errno'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1377
              },
              [
                'C',
                {},
                '"dcc error get not found"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1379
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1381
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1385
              },
              [
                'C',
                {},
                '"dcc error send exists"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1387
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1389
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1391
                },
                'string ',
                [
                  'C',
                  {},
                  '$filename'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1395
              },
              [
                'C',
                {},
                '"dcc error unknown type"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1397
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1399
                },
                'string ',
                [
                  'C',
                  {},
                  '$type'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1403
              },
              [
                'C',
                {},
                '"dcc error close not found"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1405
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1407
                },
                'string ',
                [
                  'C',
                  {},
                  '$type'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1409
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1411
                },
                'string ',
                [
                  'C',
                  {},
                  '$filename'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 1417
            },
            [
              'F',
              {},
              'autoignore.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1419
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1421
              },
              [
                'C',
                {},
                '"autoignore new"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1423
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1425
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1427
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Irc::Autoignore'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Irc::Autoignore'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$autoignore'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1431
              },
              [
                'C',
                {},
                '"autoignore remove"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1433
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1435
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1437
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Irc::Autoignore'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Irc::Autoignore'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$autoignore'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 1443
            },
            [
              'F',
              {},
              'flood.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1445
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1447
              },
              [
                'C',
                {},
                '"flood"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1449
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1451
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1453
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1455
                },
                'string ',
                [
                  'C',
                  {},
                  '$host'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1457
                },
                'int ',
                [
                  'C',
                  {},
                  '$level'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1459
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 1465
            },
            [
              'F',
              {},
              'notifylist.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1467
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1469
              },
              [
                'C',
                {},
                '"notifylist new"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1471
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1473
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Irc::Notifylist'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Irc::Notifylist'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$notify_list'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1477
              },
              [
                'C',
                {},
                '"notifylist remove"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1479
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1481
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Irc::Notifylist'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Irc::Notifylist'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$notify_list'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1485
              },
              [
                'C',
                {},
                '"notifylist joined"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1487
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1489
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1491
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1493
                },
                'string ',
                [
                  'C',
                  {},
                  '$user'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1495
                },
                'string ',
                [
                  'C',
                  {},
                  '$host'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1497
                },
                'string ',
                [
                  'C',
                  {},
                  '$real_name'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1499
                },
                'string ',
                [
                  'C',
                  {},
                  '$away_message'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1503
              },
              [
                'C',
                {},
                '"notifylist away changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1505
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1507
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1509
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1511
                },
                'string ',
                [
                  'C',
                  {},
                  '$user'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1513
                },
                'string ',
                [
                  'C',
                  {},
                  '$host'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1515
                },
                'string ',
                [
                  'C',
                  {},
                  '$real_name'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1517
                },
                'string ',
                [
                  'C',
                  {},
                  '$away_message'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1521
              },
              [
                'C',
                {},
                '"notifylist left"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1523
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1525
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1527
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1529
                },
                'string ',
                [
                  'C',
                  {},
                  '$user'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1531
                },
                'string ',
                [
                  'C',
                  {},
                  '$host'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1533
                },
                'string ',
                [
                  'C',
                  {},
                  '$real_name'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1535
                },
                'string ',
                [
                  'C',
                  {},
                  '$away_message'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 1541
            },
            [
              'F',
              {},
              'proxy/listen.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1543
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1545
              },
              [
                'C',
                {},
                '"proxy client connected"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1547
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1549
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Irc::Client'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Irc::Client'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$client'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1553
              },
              [
                'C',
                {},
                '"proxy client disconnected"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1555
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1557
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Irc::Client'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Irc::Client'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$client'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1561
              },
              [
                'C',
                {},
                '"proxy client command"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1563
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1565
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Irc::Client'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Irc::Client'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$client'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1567
                },
                'string ',
                [
                  'C',
                  {},
                  '$args'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1569
                },
                'string ',
                [
                  'C',
                  {},
                  '$data'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1573
              },
              [
                'C',
                {},
                '"proxy client dump"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1575
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1577
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Irc::Client'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Irc::Client'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$client'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1579
                },
                'string ',
                [
                  'C',
                  {},
                  '$data'
                ]
              ]
            ]
          ],
          [
            'head2',
            {
              'start_line' => 1585
            },
            'Display (FE) Common'
          ],
          [
            'Para',
            {
              'start_line' => 1587
            },
            [
              'B',
              {},
              'Requires to work properly:'
            ]
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1589
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1591
              },
              [
                'C',
                {},
                '"gui print text"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1593
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1595
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1597
                },
                'int ',
                [
                  'C',
                  {},
                  '$fg'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1599
                },
                'int ',
                [
                  'C',
                  {},
                  '$bg'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1601
                },
                'int ',
                [
                  'C',
                  {},
                  '$flags'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1603
                },
                'string ',
                [
                  'C',
                  {},
                  '$text'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1605
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::TextDest'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::TextDest'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$text_dest'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1609
              },
              [
                'C',
                {},
                '"gui print text finished"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1611
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1613
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ]
            ],
            [
              'Para',
              {
                'start_line' => 1617
              },
              '(Can be used to determine when all ',
              [
                'C',
                {},
                '"gui print text"'
              ],
              's are sent (not required))'
            ]
          ],
          [
            'Para',
            {
              'start_line' => 1622
            },
            [
              'B',
              {},
              'Provides signals:'
            ]
          ],
          [
            'head3',
            {
              'start_line' => 1624
            },
            [
              'F',
              {},
              'completion.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1626
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1628
              },
              [
                'C',
                {},
                '"complete word"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1630
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1632
                },
                'arrayref of strings ',
                [
                  'C',
                  {},
                  '$strings_ref'
                ]
              ],
              [
                'Para',
                {
                  'start_line' => 1634
                },
                'An arrayref which can be modified to add additional completion candidates.'
              ],
              [
                'Para',
                {
                  'start_line' => 1636
                },
                'For example:'
              ],
              [
                'Verbatim',
                {
                  'xml:space' => 'preserve',
                  'start_line' => 1638
                },
                '    push @$strings_ref, "another_candidate";'
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1640
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1642
                },
                'string ',
                [
                  'C',
                  {},
                  '$word'
                ]
              ],
              [
                'Para',
                {
                  'start_line' => 1644
                },
                'The prefix of the word currently being typed.'
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1646
                },
                'string ',
                [
                  'C',
                  {},
                  '$linestart'
                ]
              ],
              [
                'Para',
                {
                  'start_line' => 1648
                },
                'The contents of the input line up to (but not including) the current word prefix ',
                [
                  'C',
                  {},
                  '$word'
                ],
                '.'
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1651
                },
                'int ',
                [
                  'C',
                  {},
                  '$want_space'
                ]
              ],
              [
                'Para',
                {
                  'start_line' => 1653
                },
                'A scalar reference which can be set to indicate if tab completion of these candidates should be appended with a space.'
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 1660
            },
            [
              'F',
              {},
              'fe-common-core.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1662
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1664
              },
              [
                'C',
                {},
                '"irssi init read settings"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1666
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1668
                },
                [
                  'I',
                  {},
                  'None'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 1674
            },
            [
              'F',
              {},
              'fe-exec.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1676
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1678
              },
              [
                'C',
                {},
                '"exec new"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1680
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1682
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Process'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Process'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$process'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1686
              },
              [
                'C',
                {},
                '"exec remove"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1688
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1690
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Process'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Process'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$process'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1692
                },
                'int ',
                [
                  'C',
                  {},
                  '$status'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1696
              },
              [
                'C',
                {},
                '"exec input"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1698
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1700
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Process'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Process'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$process'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1702
                },
                'string ',
                [
                  'C',
                  {},
                  '$text'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 1708
            },
            [
              'F',
              {},
              'fe-messages.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1710
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1712
              },
              [
                'C',
                {},
                '"message public"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1714
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1716
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1718
                },
                'string ',
                [
                  'C',
                  {},
                  '$msg'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1720
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1722
                },
                'string ',
                [
                  'C',
                  {},
                  '$address'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1724
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1728
              },
              [
                'C',
                {},
                '"message private"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1730
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1732
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1734
                },
                'string ',
                [
                  'C',
                  {},
                  '$msg'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1736
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1738
                },
                'string ',
                [
                  'C',
                  {},
                  '$address'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1742
              },
              [
                'C',
                {},
                '"message own_public"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1744
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1746
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1748
                },
                'string ',
                [
                  'C',
                  {},
                  '$msg'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1750
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1754
              },
              [
                'C',
                {},
                '"message own_private"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1756
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1758
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1760
                },
                'string ',
                [
                  'C',
                  {},
                  '$msg'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1762
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1764
                },
                'string ',
                [
                  'C',
                  {},
                  '$original_target'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1768
              },
              [
                'C',
                {},
                '"message join"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1770
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1772
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1774
                },
                'string ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1776
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1778
                },
                'string ',
                [
                  'C',
                  {},
                  '$address'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1782
              },
              [
                'C',
                {},
                '"message part"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1784
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1786
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1788
                },
                'string ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1790
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1792
                },
                'string ',
                [
                  'C',
                  {},
                  '$address'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1794
                },
                'string ',
                [
                  'C',
                  {},
                  '$reason'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1798
              },
              [
                'C',
                {},
                '"message quit"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1800
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1802
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1804
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1806
                },
                'string ',
                [
                  'C',
                  {},
                  '$address'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1808
                },
                'string ',
                [
                  'C',
                  {},
                  '$reason'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1812
              },
              [
                'C',
                {},
                '"message kick"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1814
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1816
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1818
                },
                'string ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1820
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1822
                },
                'string ',
                [
                  'C',
                  {},
                  '$kicker'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1824
                },
                'string ',
                [
                  'C',
                  {},
                  '$address'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1826
                },
                'string ',
                [
                  'C',
                  {},
                  '$reason'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1830
              },
              [
                'C',
                {},
                '"message nick"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1832
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1834
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1836
                },
                'string ',
                [
                  'C',
                  {},
                  '$new_nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1838
                },
                'string ',
                [
                  'C',
                  {},
                  '$old_nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1840
                },
                'string ',
                [
                  'C',
                  {},
                  '$address'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1844
              },
              [
                'C',
                {},
                '"message own_nick"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1846
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1848
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1850
                },
                'string ',
                [
                  'C',
                  {},
                  '$new_nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1852
                },
                'string ',
                [
                  'C',
                  {},
                  '$old_nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1854
                },
                'string ',
                [
                  'C',
                  {},
                  '$address'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1858
              },
              [
                'C',
                {},
                '"message invite"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1860
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1862
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1864
                },
                'string ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1866
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1868
                },
                'string ',
                [
                  'C',
                  {},
                  '$address'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1872
              },
              [
                'C',
                {},
                '"message topic"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1874
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1876
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1878
                },
                'string ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1880
                },
                'string ',
                [
                  'C',
                  {},
                  '$topic'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1882
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1884
                },
                'string ',
                [
                  'C',
                  {},
                  '$address'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 1890
            },
            [
              'F',
              {},
              'keyboard.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1892
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1894
              },
              [
                'C',
                {},
                '"keyinfo created"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1896
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1898
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Keyinfo'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Keyinfo'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$key_info'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1902
              },
              [
                'C',
                {},
                '"keyinfo destroyed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1904
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1906
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Keyinfo'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Keyinfo'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$key_info'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 1912
            },
            [
              'F',
              {},
              'printtext.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1914
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1916
              },
              [
                'C',
                {},
                '"print text"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1918
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1920
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::TextDest'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::TextDest'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$text_dest'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1922
                },
                'string ',
                [
                  'C',
                  {},
                  '$text'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1924
                },
                'string ',
                [
                  'C',
                  {},
                  '$stripped_text'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 1930
            },
            [
              'F',
              {},
              'themes.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1932
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1934
              },
              [
                'C',
                {},
                '"theme created"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1936
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1938
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Theme'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Theme'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$theme'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1942
              },
              [
                'C',
                {},
                '"theme destroyed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1944
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1946
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Theme'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Theme'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$theme'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 1952
            },
            [
              'F',
              {},
              'window-activity.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 1954
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1956
              },
              [
                'C',
                {},
                '"window hilight"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1958
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1960
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1964
              },
              [
                'C',
                {},
                '"window dehilight"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1966
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1968
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1972
              },
              [
                'C',
                {},
                '"window activity"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1974
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1976
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1978
                },
                'int ',
                [
                  'C',
                  {},
                  '$old_level'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1982
              },
              [
                'C',
                {},
                '"window item hilight"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1984
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1986
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Windowitem'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Windowitem'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window_item'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 1990
              },
              [
                'C',
                {},
                '"window item activity"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 1992
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1994
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Windowitem'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Windowitem'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window_item'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 1996
                },
                'int ',
                [
                  'C',
                  {},
                  '$old_level'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 2002
            },
            [
              'F',
              {},
              'window-items.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 2004
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2006
              },
              [
                'C',
                {},
                '"window item new"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2008
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2010
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2012
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Windowitem'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Windowitem'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window_item'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2016
              },
              [
                'C',
                {},
                '"window item remove"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2018
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2020
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2022
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Windowitem'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Windowitem'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window_item'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2026
              },
              [
                'C',
                {},
                '"window item moved"'
              ]
            ],
            [
              'Para',
              {
                'start_line' => 2028
              },
              [
                'B',
                {},
                'TODO: Check ordering of arguments from/to here'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2030
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2032
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window_from'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2034
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Windowitem'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Windowitem'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window_item'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2036
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window_to'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2040
              },
              [
                'C',
                {},
                '"window item changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2042
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2044
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2046
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Windowitem'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Windowitem'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window_item'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2050
              },
              [
                'C',
                {},
                '"window item server changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2052
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2054
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2056
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Windowitem'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Windowitem'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window_item'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 2062
            },
            [
              'F',
              {},
              'windows.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 2064
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2066
              },
              [
                'C',
                {},
                '"window created"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2068
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2070
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2074
              },
              [
                'C',
                {},
                '"window destroyed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2076
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2078
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2082
              },
              [
                'C',
                {},
                '"window changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2084
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2086
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2088
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$old_window'
                ]
              ]
            ],
            [
              'Para',
              {
                'start_line' => 2092
              },
              [
                'B',
                {},
                'TODO: does this fire if you dont\' change windows? (eg: send a switch commandf for the window you\'re already on)'
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2095
              },
              [
                'C',
                {},
                '"window changed automatic"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2097
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2099
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2103
              },
              [
                'C',
                {},
                '"window server changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2105
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2107
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2109
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2113
              },
              [
                'C',
                {},
                '"window refnum changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2115
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2117
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2119
                },
                'int ',
                [
                  'C',
                  {},
                  '$old_refnum'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2123
              },
              [
                'C',
                {},
                '"window name changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2125
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2127
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2131
              },
              [
                'C',
                {},
                '"window history changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2133
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2135
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2137
                },
                'string ',
                [
                  'C',
                  {},
                  '$old_name'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2141
              },
              [
                'C',
                {},
                '"window level changed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2143
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2145
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::UI::Window'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::UI::Window'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$window'
                ]
              ]
            ]
          ],
          [
            'head2',
            {
              'start_line' => 2151
            },
            'Display (FE) IRC'
          ],
          [
            'head3',
            {
              'start_line' => 2153
            },
            [
              'F',
              {},
              'fe-events.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 2155
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2157
              },
              [
                'C',
                {},
                '"default event numeric"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2159
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2161
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2163
                },
                'string ',
                [
                  'C',
                  {},
                  '$data'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2165
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2167
                },
                'string ',
                [
                  'C',
                  {},
                  '$address'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 2173
            },
            [
              'F',
              {},
              'fe-irc-messages.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 2175
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2177
              },
              [
                'C',
                {},
                '"message irc op_public"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2179
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2181
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2183
                },
                'string ',
                [
                  'C',
                  {},
                  '$msg'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2185
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2187
                },
                'string ',
                [
                  'C',
                  {},
                  '$address'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2189
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2193
              },
              [
                'C',
                {},
                '"message irc own_wall"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2195
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2197
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2199
                },
                'string ',
                [
                  'C',
                  {},
                  '$msg'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2201
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2205
              },
              [
                'C',
                {},
                '"message irc own_action"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2207
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2209
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2211
                },
                'string ',
                [
                  'C',
                  {},
                  '$msg'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2213
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2217
              },
              [
                'C',
                {},
                '"message irc action"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2219
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2221
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2223
                },
                'string ',
                [
                  'C',
                  {},
                  '$msg'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2225
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2227
                },
                'string ',
                [
                  'C',
                  {},
                  '$address'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2229
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2233
              },
              [
                'C',
                {},
                '"message irc own_notice"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2235
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2237
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2239
                },
                'string ',
                [
                  'C',
                  {},
                  '$msg'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2241
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2245
              },
              [
                'C',
                {},
                '"message irc notice"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2247
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2249
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2251
                },
                'string ',
                [
                  'C',
                  {},
                  '$msg'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2253
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2255
                },
                'string ',
                [
                  'C',
                  {},
                  '$address'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2257
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2261
              },
              [
                'C',
                {},
                '"message irc own_ctcp"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2263
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2265
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2267
                },
                'string ',
                [
                  'C',
                  {},
                  '$cmd'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2269
                },
                'string ',
                [
                  'C',
                  {},
                  '$data'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2271
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2275
              },
              [
                'C',
                {},
                '"message irc ctcp"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2277
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2279
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2281
                },
                'string ',
                [
                  'C',
                  {},
                  '$cmd'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2283
                },
                'string ',
                [
                  'C',
                  {},
                  '$data'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2285
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2287
                },
                'string ',
                [
                  'C',
                  {},
                  '$address'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2289
                },
                'string ',
                [
                  'C',
                  {},
                  '$target'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 2295
            },
            [
              'F',
              {},
              'fe-modes.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 2297
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2299
              },
              [
                'C',
                {},
                '"message irc mode"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2301
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2303
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Server'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Server'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$server'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2305
                },
                'string ',
                [
                  'C',
                  {},
                  '$channel'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2307
                },
                'string ',
                [
                  'C',
                  {},
                  '$nick'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2309
                },
                'string ',
                [
                  'C',
                  {},
                  '$address'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2311
                },
                'string ',
                [
                  'C',
                  {},
                  '$mode'
                ]
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 2317
            },
            [
              'F',
              {},
              'dcc/fe-dcc-chat-messages.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => 4,
              'start_line' => 2319
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2321
              },
              [
                'C',
                {},
                '"message dcc own"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2323
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2325
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2327
                },
                'string ',
                [
                  'C',
                  {},
                  '$msg'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2331
              },
              [
                'C',
                {},
                '"message dcc own_action"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2333
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2335
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2337
                },
                'string ',
                [
                  'C',
                  {},
                  '$msg'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2341
              },
              [
                'C',
                {},
                '"message dcc own_ctcp"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2343
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2345
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2347
                },
                'string ',
                [
                  'C',
                  {},
                  '$cmd'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2349
                },
                'string ',
                [
                  'C',
                  {},
                  '$data'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2353
              },
              [
                'C',
                {},
                '"message dcc"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2355
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2357
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2359
                },
                'string ',
                [
                  'C',
                  {},
                  '$msg'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2363
              },
              [
                'C',
                {},
                '"message dcc action"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2365
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2367
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2369
                },
                'string ',
                [
                  'C',
                  {},
                  '$msg'
                ]
              ]
            ],
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2373
              },
              [
                'C',
                {},
                '"message dcc ctcp"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2375
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2377
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Dcc'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Dcc'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$dcc'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2379
                },
                'string ',
                [
                  'C',
                  {},
                  '$cmd'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2381
                },
                'string ',
                [
                  'C',
                  {},
                  '$data'
                ]
              ]
            ]
          ],
          [
            'head2',
            {
              'start_line' => 2387
            },
            'Display (FE) Text'
          ],
          [
            'head3',
            {
              'start_line' => 2389
            },
            [
              'F',
              {},
              'gui-readline.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 2391
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2393
              },
              [
                'C',
                {},
                '"gui key pressed"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2395
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2397
                },
                'int ',
                [
                  'C',
                  {},
                  '$key'
                ]
              ]
            ],
            [
              'Para',
              {
                'start_line' => 2401
              },
              'Notes:'
            ],
            [
              'Para',
              {
                'start_line' => 2403
              },
              'Ordinary keys ',
              [
                'C',
                {},
                'a-zA-Z'
              ],
              ' are their ordinal (ascii) equivalents.'
            ],
            [
              'Para',
              {
                'start_line' => 2405
              },
              'Ctrl-key begins at 1 (',
              [
                'C',
                {},
                'C-a'
              ],
              '), but skips 13?, ',
              [
                'C',
                {},
                'C-j'
              ],
              ' and ',
              [
                'C',
                {},
                'C-m'
              ],
              ' both give the same as ',
              [
                'C',
                {},
                'RET'
              ],
              ' (10). Tab and ',
              [
                'C',
                {},
                'C-i'
              ],
              ' are equivalent (9). ',
              [
                'C',
                {},
                'C-o'
              ],
              ' does not appear to send an observable sequence.'
            ],
            [
              'Para',
              {
                'start_line' => 2409
              },
              [
                'C',
                {},
                'BS'
              ],
              ' sends 127.'
            ],
            [
              'Para',
              {
                'start_line' => 2411
              },
              [
                'C',
                {},
                'meta-',
                '<',
                'key',
                '>'
              ],
              ' sends a 27 (ESC) followed by the original key value.'
            ],
            [
              'Para',
              {
                'start_line' => 2413
              },
              'Arrow keys send usual meta-stuff (',
              [
                'C',
                {},
                '\\e[',
                [
                  'I',
                  {},
                  'ABCD'
                ]
              ],
              ').'
            ],
            [
              'Para',
              {
                'start_line' => 2415
              },
              [
                'B',
                {},
                'TODO: Turn this into some sort of list'
              ]
            ]
          ],
          [
            'head3',
            {
              'start_line' => 2419
            },
            [
              'F',
              {},
              'gui-printtext.c'
            ],
            ':'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 2421
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2423
              },
              [
                'C',
                {},
                '"beep"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2425
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2427
                },
                [
                  'I',
                  {},
                  'None'
                ]
              ]
            ]
          ],
          [
            'head2',
            {
              'start_line' => 2433
            },
            'Perl Scripting'
          ],
          [
            'over-text',
            {
              '~type' => 'text',
              'indent' => '4',
              'start_line' => 2435
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => 2437
              },
              [
                'C',
                {},
                '"script error"'
              ]
            ],
            [
              'over-text',
              {
                '~type' => 'text',
                'indent' => 4,
                'start_line' => 2439
              },
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2441
                },
                [
                  'L',
                  {
                    'to' => bless( [
                                     '',
                                     {},
                                     'Irssi::Script'
                                   ], 'Pod::Simple::LinkSection' ),
                    'type' => 'pod',
                    'content-implicit' => 'yes'
                  },
                  'Irssi::Script'
                ],
                ' ',
                [
                  'C',
                  {},
                  '$script'
                ]
              ],
              [
                'item-text',
                {
                  '~type' => 'text',
                  'start_line' => 2443
                },
                'string ',
                [
                  'C',
                  {},
                  '$error_msg'
                ]
              ]
            ]
          ],
          [
            'for',
            {
              'target' => 'irssi_signal_defs',
              '~really' => '=for',
              '~ignore' => 0,
              'target_matching' => 'irssi_signal_defs',
              'start_line' => 2449,
              '~resolve' => 0
            },
            [
              'Data',
              {
                'xml:space' => 'preserve',
                'start_line' => 2449
              },
              'END OF SIGNAL DEFINITIONS'
            ]
          ],
          [
            'head1',
            {
              'start_line' => 2451
            },
            'SIGNAL AUTO-GENERATION'
          ],
          [
            'Para',
            {
              'start_line' => 2453
            },
            'This file is used to auto-generate the signal definitions used by Irssi, and hence must be edited in order to add new signals.'
          ],
          [
            'head2',
            {
              'start_line' => 2456
            },
            'Format'
          ],
          [
            'head1',
            {
              'errata' => 1,
              'start_line' => -321
            },
            'POD ERRORS'
          ],
          [
            'Para',
            {
              'errata' => 1,
              'start_line' => -321,
              '~cooked' => 1
            },
            'Hey! ',
            [
              'B',
              {},
              'The above document had some coding errors, which are explained below:'
            ]
          ],
          [
            'over-text',
            {
              'errata' => 1,
              '~type' => 'text',
              'indent' => 4,
              'start_line' => -321
            },
            [
              'item-text',
              {
                '~type' => 'text',
                'start_line' => -321
              },
              'Around line 2092:'
            ],
            [
              'Para',
              {
                'start_line' => -321,
                '~cooked' => 1
              },
              'Unterminated B<...> sequence'
            ]
          ]
        ];
