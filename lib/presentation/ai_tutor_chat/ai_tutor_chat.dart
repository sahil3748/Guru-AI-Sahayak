import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/chat_input_widget.dart';
import './widgets/chat_message_widget.dart';
import './widgets/hint_system_widget.dart';
import './widgets/quick_reply_widget.dart';
import './widgets/subject_prompt_widget.dart';
import './widgets/typing_indicator_widget.dart';

class AiTutorChat extends StatefulWidget {
  const AiTutorChat({Key? key}) : super(key: key);

  @override
  State<AiTutorChat> createState() => _AiTutorChatState();
}

class _AiTutorChatState extends State<AiTutorChat> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  bool _showQuickReplies = true;
  bool _showSubjectPrompts = true;
  String _currentTopic = '';

  // Mock data for chat functionality
  final List<Map<String, dynamic>> _mockMessages = [
    {
      'id': 1,
      'content':
          'Hello! I\'m GuruAI, your friendly learning companion! 🎓 I\'m here to help you understand your homework step by step. What subject would you like to work on today?',
      'isUser': false,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'type': 'text',
    },
  ];

  final List<String> _quickReplies = [
    'Help with Math',
    'Science Question',
    'English Grammar',
    'History Facts',
    'Need Explanation',
    'Check My Work',
  ];

  final List<Map<String, dynamic>> _subjects = [
    {
      'name': 'Mathematics',
      'icon': 'calculate',
      'color': 0xFF3182CE,
      'prompt':
          'I need help with a Math problem. Can you guide me through it step by step?',
    },
    {
      'name': 'Science',
      'icon': 'science',
      'color': 0xFF38A169,
      'prompt':
          'I have a Science question. Can you help me understand the concept?',
    },
    {
      'name': 'English',
      'icon': 'menu_book',
      'color': 0xFFE53E3E,
      'prompt':
          'I need help with English grammar or writing. Can you assist me?',
    },
    {
      'name': 'History',
      'icon': 'history_edu',
      'color': 0xFFFBD38D,
      'prompt':
          'I want to learn about a historical topic. Can you explain it to me?',
    },
    {
      'name': 'Geography',
      'icon': 'public',
      'color': 0xFF9F7AEA,
      'prompt':
          'I have a Geography question. Can you help me understand it better?',
    },
    {
      'name': 'General',
      'icon': 'school',
      'color': 0xFF4FD1C7,
      'prompt': 'I have a general question about my studies. Can you help me?',
    },
  ];

  final List<String> _currentHints = [
    'Let\'s start by identifying what type of problem this is.',
    'Think about what information you already have.',
    'What formula or concept might apply here?',
    'Try breaking the problem into smaller steps.',
    'What would be your first step to solve this?',
  ];

  final Map<String, List<String>> _aiResponses = {
    'math': [
      'Great choice! Math can be really fun when we break it down step by step. What specific topic are you working on? Is it algebra, geometry, arithmetic, or something else?',
      'I love helping with math problems! Remember, every complex problem is just a series of simple steps. What\'s the problem you\'re working on?',
      'Math is like solving puzzles! 🧩 Let\'s work through this together. Can you share the problem or tell me what concept you\'re struggling with?',
    ],
    'science': [
      'Science is amazing! 🔬 There\'s so much to discover and understand. What area of science interests you today - physics, chemistry, biology, or earth science?',
      'I\'m excited to explore science with you! Science helps us understand how the world works. What question do you have?',
      'Let\'s dive into the wonderful world of science! What concept or experiment would you like to understand better?',
    ],
    'english': [
      'English is such a beautiful language! 📚 Whether it\'s grammar, writing, or literature, I\'m here to help. What would you like to work on?',
      'Great! English skills are so important for expressing our thoughts clearly. Are you working on grammar, writing an essay, or reading comprehension?',
      'I love helping with English! Good communication skills will serve you well in all subjects. What can I help you with today?',
    ],
    'history': [
      'History is like time travel! 🏛️ We get to learn about amazing people and events from the past. What historical period or topic interests you?',
      'I find history fascinating! Every event has a story and connects to our present. What would you like to explore?',
      'History helps us understand how we got to where we are today. What historical question can I help you with?',
    ],
    'general': [
      'I\'m here to help with any subject! 🌟 Learning is a journey, and every question is a step forward. What\'s on your mind?',
      'No question is too small or too big! I\'m here to support your learning journey. What would you like to understand better?',
      'Every day is a chance to learn something new! What can I help you discover today?',
    ],
  };

  @override
  void initState() {
    super.initState();
    _messages.addAll(_mockMessages);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String content, {String type = 'text', String? imageUrl}) {
    if (content.trim().isEmpty && type == 'text') return;

    final userMessage = {
      'id': _messages.length + 1,
      'content': content,
      'isUser': true,
      'timestamp': DateTime.now(),
      'type': type,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
      _showQuickReplies = false;
      _showSubjectPrompts = false;
    });

    _scrollToBottom();
    _generateAIResponse(content, type);
  }

  void _generateAIResponse(String userMessage, String messageType) {
    // Simulate AI processing time
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      String response = _getContextualResponse(userMessage, messageType);

      final aiMessage = {
        'id': _messages.length + 1,
        'content': response,
        'isUser': false,
        'timestamp': DateTime.now(),
        'type': 'text',
      };

      setState(() {
        _messages.add(aiMessage);
        _isTyping = false;
        _showQuickReplies = _messages.length > 2;
      });

      _scrollToBottom();
    });
  }

  String _getContextualResponse(String userMessage, String messageType) {
    final lowerMessage = userMessage.toLowerCase();

    if (messageType == 'image') {
      return 'I can see you\'ve shared an image! 📸 Let me analyze this for you. This looks like a homework problem. Can you tell me what specific part you\'re having trouble with? I\'ll guide you through it step by step without giving away the answer directly.';
    }

    if (messageType == 'voice') {
      return 'Thanks for the voice message! 🎤 I heard your question. Let me help you work through this. Remember, the best way to learn is by understanding each step, so I\'ll guide you rather than just give you the answer.';
    }

    // Determine subject context
    String subject = 'general';
    if (lowerMessage.contains('math') ||
        lowerMessage.contains('calculate') ||
        lowerMessage.contains('equation') ||
        lowerMessage.contains('number')) {
      subject = 'math';
    } else if (lowerMessage.contains('science') ||
        lowerMessage.contains('experiment') ||
        lowerMessage.contains('physics') ||
        lowerMessage.contains('chemistry')) {
      subject = 'science';
    } else if (lowerMessage.contains('english') ||
        lowerMessage.contains('grammar') ||
        lowerMessage.contains('writing') ||
        lowerMessage.contains('essay')) {
      subject = 'english';
    } else if (lowerMessage.contains('history') ||
        lowerMessage.contains('historical') ||
        lowerMessage.contains('past') ||
        lowerMessage.contains('ancient')) {
      subject = 'history';
    }

    _currentTopic = subject;

    final responses = _aiResponses[subject] ?? _aiResponses['general']!;
    final randomResponse =
        responses[DateTime.now().millisecond % responses.length];

    return randomResponse;
  }

  void _handleQuickReply(String reply) {
    _sendMessage(reply);
  }

  void _handleSubjectSelection(String prompt) {
    _sendMessage(prompt);
  }

  void _handleImageMessage(String imagePath) {
    _sendMessage('I\'ve uploaded an image for help',
        type: 'image', imageUrl: imagePath);
  }

  void _handleVoiceMessage(String audioPath) {
    _sendMessage('Voice message: Can you help me with this question?',
        type: 'voice');
  }

  void _handleHintRequest(String hint) {
    final hintMessage = {
      'id': _messages.length + 1,
      'content':
          '💡 Hint: $hint\n\nTake your time to think about this. What do you think the next step should be?',
      'isUser': false,
      'timestamp': DateTime.now(),
      'type': 'text',
    };

    setState(() {
      _messages.add(hintMessage);
    });

    _scrollToBottom();
  }

  void _shareConversation() {
    HapticFeedback.lightImpact();
    // In a real app, this would share the conversation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Conversation shared successfully!'),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
      ),
    );
  }

  void _searchConversation() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Search Conversations',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Search for topics, questions...',
            prefixIcon: Icon(Icons.search),
          ),
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Search feature coming soon!'),
                  backgroundColor: AppTheme.primaryBlue,
                ),
              );
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(5.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'psychology',
                  color: AppTheme.surfaceWhite,
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chat with GuruAI',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Your AI Learning Companion',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.onSurfaceSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _searchConversation,
            icon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.onSurfacePrimary,
              size: 6.w,
            ),
          ),
          IconButton(
            onPressed: _shareConversation,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.onSurfacePrimary,
              size: 6.w,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'teacher_dashboard':
                  Navigator.pushNamed(context, '/teacher-dashboard');
                  break;
                case 'student_dashboard':
                  Navigator.pushNamed(context, '/student-dashboard');
                  break;
                case 'worksheet_generator':
                  Navigator.pushNamed(context, '/ai-worksheet-generator');
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'teacher_dashboard',
                child: Text('Teacher Dashboard'),
              ),
              const PopupMenuItem(
                value: 'student_dashboard',
                child: Text('Student Dashboard'),
              ),
              const PopupMenuItem(
                value: 'worksheet_generator',
                child: Text('Worksheet Generator'),
              ),
            ],
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.onSurfacePrimary,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
              itemCount: _messages.length +
                  (_isTyping ? 1 : 0) +
                  (_showSubjectPrompts ? 1 : 0) +
                  (_showQuickReplies ? 1 : 0) +
                  (_currentTopic.isNotEmpty && _messages.length > 3 ? 1 : 0),
              itemBuilder: (context, index) {
                // Subject prompts
                if (_showSubjectPrompts && index == 0) {
                  return SubjectPromptWidget(
                    subjects: _subjects,
                    onSubjectSelected: _handleSubjectSelection,
                  );
                }

                // Adjust index for subject prompts
                int messageIndex = index;
                if (_showSubjectPrompts) messageIndex--;

                // Messages
                if (messageIndex < _messages.length) {
                  final message = _messages[messageIndex];
                  return ChatMessageWidget(
                    message: message,
                    isUser: message['isUser'] as bool,
                  );
                }

                // Adjust index for messages
                messageIndex -= _messages.length;

                // Typing indicator
                if (_isTyping && messageIndex == 0) {
                  return const TypingIndicatorWidget();
                }

                // Adjust index for typing indicator
                if (_isTyping) messageIndex--;

                // Hint system
                if (_currentTopic.isNotEmpty &&
                    _messages.length > 3 &&
                    messageIndex == 0) {
                  return HintSystemWidget(
                    hints: _currentHints,
                    onHintRequested: _handleHintRequest,
                  );
                }

                // Adjust index for hint system
                if (_currentTopic.isNotEmpty && _messages.length > 3)
                  messageIndex--;

                // Quick replies
                if (_showQuickReplies && messageIndex == 0) {
                  return QuickReplyWidget(
                    quickReplies: _quickReplies,
                    onQuickReply: _handleQuickReply,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          ChatInputWidget(
            onSendMessage: _sendMessage,
            onSendImage: _handleImageMessage,
            onSendVoice: _handleVoiceMessage,
          ),
        ],
      ),
    );
  }
}
