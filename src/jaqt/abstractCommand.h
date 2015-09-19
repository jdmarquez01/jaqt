//___________________________________________________________________________//
//
// Software License Agreement
//
// The SonarKit Project (TSKIT) - www.sonarkitproject.org
//
// Copyright (c) 2014 JAD
//
// All rights reserved.
//
// This source code is free software; you can redistribute it and/or
// modify it under the terms of the TSKIT License, Version 1.0
//
//___________________________________________________________________________//
#ifndef _ABSTRACT_COMMAND__H_
#define _ABSTRACT_COMMAND__H_

class ReaderDocument;

class abstractDocument;
class IDocument;

class abstractVisitor
{
  public:
    virtual ~abstractVisitor() {}
};

#include <type_traits>
#include <functional>

class ReaderDocumentVisitor : public abstractVisitor
{
  public:
    //virtual ~ReaderDocumentVisitor() {}
    virtual void Visit(ReaderDocument &) = 0;
};


class TestReaderDocumentVisitor : public ReaderDocumentVisitor
{
  public:
    TestReaderDocumentVisitor(const std::function< void ( ReaderDocument&) > &t): t_(t) {}
    void Visit(ReaderDocument &d)
    {

      t_(d);
    }
    const std::function< void ( ReaderDocument&) > &t_;
};

inline
TestReaderDocumentVisitor Test(const std::function<void(ReaderDocument&)> &t) { return TestReaderDocumentVisitor (t);}


#endif
