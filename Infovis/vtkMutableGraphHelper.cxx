/*=========================================================================

  Program:   Visualization Toolkit
  Module:    vtkMutableGraphHelper.cxx

  Copyright (c) Ken Martin, Will Schroeder, Bill Lorensen
  All rights reserved.
  See Copyright.txt or http://www.kitware.com/Copyright.htm for details.

     This software is distributed WITHOUT ANY WARRANTY; without even
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
     PURPOSE.  See the above copyright notice for more information.

=========================================================================*/
/*----------------------------------------------------------------------------
 Copyright (c) Sandia Corporation
 See Copyright.txt or http://www.paraview.org/HTML/Copyright.html for details.
----------------------------------------------------------------------------*/

#include "vtkMutableGraphHelper.h"

#include "vtkGraphEdge.h"
#include "vtkMutableDirectedGraph.h"
#include "vtkMutableUndirectedGraph.h"
#include "vtkObjectFactory.h"

vtkCxxSetObjectMacro(vtkMutableGraphHelper, InternalGraph, vtkGraph);
vtkCxxRevisionMacro(vtkMutableGraphHelper, "1.1");
vtkStandardNewMacro(vtkMutableGraphHelper);
//----------------------------------------------------------------------------
vtkMutableGraphHelper::vtkMutableGraphHelper()
{
  this->InternalGraph = 0;
  this->DirectedGraph = 0;
  this->UndirectedGraph = 0;
  this->GraphEdge = vtkGraphEdge::New();
  this->GraphEdge->SetId(-1);
  this->GraphEdge->SetSource(-1);
  this->GraphEdge->SetTarget(-1);
}

//----------------------------------------------------------------------------
vtkMutableGraphHelper::~vtkMutableGraphHelper()
{
  if (this->InternalGraph)
    {
    this->InternalGraph->Delete();
    }
  this->GraphEdge->Delete();
}

//----------------------------------------------------------------------------
void vtkMutableGraphHelper::SetGraph(vtkGraph* g)
{
  this->SetInternalGraph(g);
  this->DirectedGraph = vtkMutableDirectedGraph::SafeDownCast(this->InternalGraph);
  this->UndirectedGraph = vtkMutableUndirectedGraph::SafeDownCast(this->InternalGraph);
  if (!this->DirectedGraph && !this->UndirectedGraph)
    {
    vtkErrorMacro("The graph must be mutable.");
    }
}

//----------------------------------------------------------------------------
vtkGraph* vtkMutableGraphHelper::GetGraph()
{
  return this->GetInternalGraph();
}

//----------------------------------------------------------------------------
vtkIdType vtkMutableGraphHelper::AddVertex()
{
  if (!this->InternalGraph)
    {
    return -1;
    }
  if (this->DirectedGraph)
    {
    return this->DirectedGraph->AddVertex();
    }
  else
    {
    return this->UndirectedGraph->AddVertex();
    }
}

//----------------------------------------------------------------------------
vtkEdgeType vtkMutableGraphHelper::AddEdge(vtkIdType u, vtkIdType v)
{
  if (!this->InternalGraph)
    {
    return vtkEdgeType();
    }
  if (this->DirectedGraph)
    {
    return this->DirectedGraph->AddEdge(u, v);
    }
  else
    {
    return this->UndirectedGraph->AddEdge(u, v);
    }
}

//----------------------------------------------------------------------------
vtkGraphEdge* vtkMutableGraphHelper::AddGraphEdge(vtkIdType u, vtkIdType v)
{
  if (!this->InternalGraph)
    {
    return this->GraphEdge;
    }
  if (this->DirectedGraph)
    {
    return this->DirectedGraph->AddGraphEdge(u, v);
    }
  else
    {
    return this->UndirectedGraph->AddGraphEdge(u, v);
    }
}

//----------------------------------------------------------------------------
void vtkMutableGraphHelper::PrintSelf(ostream& os, vtkIndent indent)
{
  this->Superclass::PrintSelf(os,indent);
  os << indent << "InternalGraph: " << (this->InternalGraph ? "" : "(null)") << endl;
  if (this->InternalGraph)
    {
    this->InternalGraph->PrintSelf(os, indent.GetNextIndent());
    }
}
